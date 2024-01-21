
# Flutter library

A collection of code snippets and widgets that show how to do certain things and to illustrate
the capabilities of Flutter.

### PermissionWidget (lib/permission.dart)

Demonstrate how to show a profile picture while not forgetting to ask the user for permissions
to their photo gallery on their device. In order for permissions to work properly on iOS and
Android we use the **permission_handler** package from pub.dev. There is some setup configuration
for iOS and Android and the app needs to add some configuration directives for both platforms.

### iOS Permissions

### Podfile

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        ## dart: PermissionGroup.photos
        'PERMISSION_PHOTOS=1',
      ]
    end
  end
end
```

### Info.plist

### Upload photos from image gallery
<key>NSPhotoLibraryUsageDescription</key>
<string>Upload photos from device gallery to server from iOS</string>

### Upload photos from camera
<key>NSCameraUsageDescription</key>
<string>Upload photos from device camera to server from iOS</string>

### Known issue 

When choosing an image from the device image gallery. iOS seems to error out with an unsupported file format exception. The package file_picker from pub.dev seems to resolve this issue. File picker will be implemented in the future but for now every time we choose an image from the device image gallery iOS will throw this error:

[Runner] findWriterForTypeAndAlternateType:119: unsupported file format 'public.heic'

### Sheet (sheet.dart)

DraggableSCrollableSheet widget with image blur and centered title. The image blurs and sharpens in conjunction with the movement of the draggable bottom sheet.

### Upload images (upload.dart)

Short code snippett that demonstrates uploading a photo
from the device image gallery.

### Scroll content horizontally (scroll.dart)
Use ListView.builder with a SizedBox containing each item in the scrollable list. The width of the SizedBox equals the width of the screen minus 100 pixels or an arbitrary value as long as the content of each list item is not too compact. The height for the list view and consequently for each item is another media query and is 20% of the screen vertically or another arbitrary value.