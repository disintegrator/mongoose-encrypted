mongoose = require 'mongoose'
strategies = require '../encryption/strategies'


class Encrypted extends mongoose.SchemaTypes.String
    cast: (val) ->
        return '' if not val
        Strategy = strategies[@options.method]
        throw new Error('unrecognised encryption method') if not Strategy?
        strategy = new Strategy @options.encryptOptions
        strategy.encrypt val


module.exports = (mongoose) ->
    mongoose.SchemaTypes.Encrypted = Encrypted
    mongoose.Types.Encrypted = Encrypted
