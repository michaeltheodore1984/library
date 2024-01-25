import os
from flask import Flask, request, abort, send_from_directory, after_this_request
import imghdr
import time
from werkzeug.utils import secure_filename
from PIL import Image, ImageOps

# The folder on the server where we want to store and user images
UPLOAD_FOLDER = './uploads/'

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024
app.config['UPLOAD_EXTENSIONS'] = ['.jpg', '.png', '.gif', '.jpeg']

# Throw a 400 error when the file is too large.
# 400 was chosen to avoid feedback with too specific information.
@app.errorhandler(400)
def too_large(e):
    return "Invalid file.", 400

# Validate the image from the first few bytes
def validate_image(stream):
    header = stream.read(512)
    stream.seek(0)
    format = imghdr.what(None, header)
    if not format:
        return None
    return '.' + (format if format != 'jpeg' else 'jpg')

@app.post('/api/upload')
def upload_file():
    # The file in the request object
    uploaded_file = request.files['file']

    # The email required to create a directory for the user on the server
    json = request.form.get('json_data')

    # Get the email from the json string
    arr = json.split(':')

    # When parsing remove the last curly brace
    cuid = arr[0]
    uid = arr[1]
    # email = arr[1].rstrip('}')

    # Check for a secure file name
    filename = secure_filename(uploaded_file.filename)

    # If both the file name and email are empty throw a 400 error
    if filename != '' and cuid != '' and uid != '' :
        file_ext = os.path.splitext(filename)[1]

        # If the image does not have an allowed extension like jpg or jpeg throw a 400 error
        if file_ext not in app.config['UPLOAD_EXTENSIONS'] or file_ext != validate_image(uploaded_file.stream) :
            abort(400)
    else :
        abort(400)

    contractor_dir = os.path.join(app.config['UPLOAD_FOLDER'] + cuid)
    # If the directory where we upload files for a specific user does not exist
    # create the directory
    if not os.path.isdir(contractor_dir) :
        os.mkdir(contractor_dir)

    # Create the directory for customer photos for each contractor
    if not os.path.isdir(contractor_dir + '/' + uid) :
        os.mkdir(contractor_dir + '/' + uid)
    
    # Upload the file
    # Here we resize the image for bandwidth purposes
    image = Image.open(uploaded_file)

    # Create the image with a smaller size up to the tuple
    # with dimensions specified. 640 x 480 is sufficient before quality loss
    # occurs. Phones are small so we don't need to have big images or high
    # resolution images with big file sizes. These values, however can be set
    # arbitrarily for testing or even production.
    image.thumbnail((640, 640))
    
    # Keep original orientation of image i.e portrait, landscape
    image = ImageOps.exif_transpose(image)

    # Use Unix timestamp to name image files
    timestamp = time.time()

    # Add the correc extension
    filename = str(timestamp) + os.path.splitext(filename)[1]

    # Save the image to disk
    image.save(os.path.join(contractor_dir +  '/' + uid, filename))

    return '', 200

""" # Serve the images
@app.route('/api/image/<cuid>/<uid>/<image>')
def upload(cuid,uid,image):
   p = app.config['UPLOAD_FOLDER'] + cuid + "/" + uid
   # Delete the photo after downloading to device to save space on the server
   @after_this_request
   def delete_photo(response):
       os.remove(os.path.join(p, image))
       return response
   return send_from_directory(p, image) """

# Serve the images
@app.route('/api/image/<cuid>/<uid>/<image>')
def upload(cuid,uid,image):
   p = app.config['UPLOAD_FOLDER'] + cuid + "/" + uid
   return send_from_directory(p, image)