mongoose = require 'mongoose'
PBKDF2Strategy = require '../encryption/strategies/PBKDF2.coffee'

class Encrypted extends mongoose.SchemaTypes.String
    cast: (val) ->
        return '' if not val
        Strategy = switch @options.method
            when 'pbkdf2' then PBKDF2Strategy
            else throw new Error 'Unrecognised encryption method'
        strategy = new Strategy @options.encryptOptions
        strategy.encrypt val


module.exports = (mongoose) ->
    mongoose.SchemaTypes.Encrypted = Encrypted
    mongoose.Types.Encrypted = Encrypted
