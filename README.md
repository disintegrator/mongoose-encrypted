mongoose-encrypted
==================

[Mongoose.js](http://mongoosejs.com/) is amazing! Out of the box, there is no way to have encrypted fields like passwords. This module is an attempt at adding this functionality.

## Features

- `SchemaTypes.Encrypted` schema type that inherits from `SchemaTypes.String`. Fields of that type are automatically encrypted when they are changed.
- `encryptedPlugin` schema plugin that adds a `checkEncrypted` method on model instances. This is used to check some input value against an encrypted field's value
- minLength validation included (default is 8)
- Support for PBKDF2 and bcrypt encryption strategy.

## Usage

### Javascript

    var mongoose = require('mongoose'),
        mongooseEncrypted = require('mongoose-encrypted').loadTypes(mongoose),
        encryptedPlugin = mongooseEncrypted.plugins.encryptedPlugin,
        Schema = mongoose.Schema,
        Encrypted = mongoose.SchemaTypes.Encrypted;

    var userSchema = new Schema({
        name: String,
        password: {
            type: Encrypted,
            method: 'pbkdf2',
            minLength: 6,
            encryptOptions: {
                iterations: 20000,
                keyLength: 32,
                saltLength: 32
            }
        }
    });

    // add plugin to schema so we can check encrypted fields with input data
    userSchema.plugin(encryptedPlugin);

    var User = mongoose.model('Test', userSchema);
    var user = new User();

    user.password = 'passw0rd';

    // notice that is encrypted immediately
    console.log(user.password);

    // Tests
    user.checkEncrypted('password', 'wrongpassword', function(err, res) {
        console.log('attempt 1: ', res ? 'success' : 'fail');
    });
    user.checkEncrypted('password', 'passw0rd', function(err, res) {
        console.log('attempt 2: ', res ? 'success' : 'fail');
    });

### Coffeescript

    mongoose = require 'mongoose'
    mongooseEncrypted = require('mongoose-encrypted').loadTypes mongoose
    encryptedPlugin = mongooseEncrypted.plugins.encryptedPlugin
    Schema = mongoose.Schema
    Encrypted = mongoose.SchemaTypes.Encrypted

    userSchema = new Schema
        name: String
        password:
            type: Encrypted
            method: 'bcrypt'
            encryptOptions:
                saltRounds: 10
                seedLength: 20

    # add plugin to schema so we can check encrypted fields with input data
    userSchema.plugin encryptedPlugin

    user = mongoose.model 'Test', userSchema

    user = new user()
    user.password = 'passw0rd'

    # Tests
    user.checkEncrypted 'password', 'wrongpassword', (err, res) ->
        console.log 'attempt 1: ', if res then 'success' else 'fail'
    user.checkEncrypted 'password', 'passw0rd', (err, res) ->
        console.log 'attempt 2: ', if res then 'success' else 'fail'


#### Heads Up

With PBKDF2 encryption strategy, `crypto.pseudoRandomBytes` is used to generate the salt.

