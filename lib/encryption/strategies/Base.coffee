module.exports = class EncryptionStrategy
    constructor: (@options) ->

    getPreamble: ->
        preamble = [@constructor.method]
        Array::push.apply preamble, @getPreambleSegments()
        preamble.join ':'

    encrypt: (value) ->
        preamble = @getPreamble()
        transformed = @transformValue value
        "#{preamble}$$#{transformed}"

    getPreambleSegments: -> throw new Error 'not implemented'

    transformValue: (value) -> throw new Error 'not implemented'

    compare: (input, encryptValue) -> throw new Error 'not implemented'
