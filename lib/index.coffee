lib =
    plugins:
        encryptedPlugin: require './plugins/encrypted'
    loadTypes: (mongoose) ->
        require('./types/encrypted') mongoose
        lib

module.exports = lib
