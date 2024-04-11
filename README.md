A password manager built with flutter and postgres. 
# The app

### Sign in

<img src="https://github.com/PandaBean18/password_manager/tree/main/pm/sign_in_pm.webp?raw=true">

### Homepage

<img src="https://cdn.discordapp.com/attachments/844189298030673940/1124691896195878952/image.png" width="500">

### Password generator

<img src="https://cdn.discordapp.com/attachments/844189298030673940/1124692053780074606/image.png" width="500">

### Adding a password

<img src="https://cdn.discordapp.com/attachments/844189298030673940/1124694179713388574/image.png" width="500">

### Deletion

<img src="https://cdn.discordapp.com/attachments/844189298030673940/1124694759009689722/image.png" width="500">
<img src="https://cdn.discordapp.com/attachments/844189298030673940/1124694865683419217/image.png" width="500">

### Editing

<img src="https://cdn.discordapp.com/attachments/844189298030673940/1124694955345072318/image.png" width="500">
<img src="https://cdn.discordapp.com/attachments/844189298030673940/1124694373095985162/image.png" width="500">

### Database

<img src="https://cdn.discordapp.com/attachments/844189298030673940/1124650415892484096/image.png" width="500">

# Security 
The main app of building this application was to learn more about symmetric encryption techniques.

The application initially prompts the user to choose a username and a password, the password here gets hashed using bcrypt and then stored in the USERS database. When storing the password for another application, the app prompts you to enter your password (of the password manager) again, this password is first checked against the hashed value to ensure that it is correct and then it is sent to a key derivation function which derives an encryption key. This encryption key is used to encrypt both the application name and password for the newly added password and then stored into the database. 

While logging in, the user has to enter the password for authentication, once the password has been authenticated, the password gets sent to the key derivation function. This key is then passed on to the BaseApp class.

Hashing function for hashing passwords - bcrypt
Hashing function for key derivation function - AES

# Password generation
The app also comes with a password generator to create strong passwords

# Pre requisites
Flutter 
PostgreSQL

# Packages used 
bcrypt(https://pub.dev/documentation/bcrypt/latest/)
pbkdf2ns(https://pub.dev/packages/pbkdf2ns)
