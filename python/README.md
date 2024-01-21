flask --app server run -p 3000 -h <host> (192.168.1.2)

Flutter
<host>:3000/api/upload (192.168.1.2)

curl -H "Content-Type: multipart/form-data" -F file=@/Users/<username>/Downloads/onboarding3.jpg -F json_data={email:username@email.com} -X POST http://127.0.0.1:3000/api/upload