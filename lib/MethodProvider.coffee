Utility = require './Utility'
AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides tooltips for global constants.
##
class ClassProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    hoverEventSelectors: '.function-call.object, .function-call.static'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            try
                value = @service.getClassMethodAt(editor, bufferPosition, name)

            catch error
                reject()
                return

            if not value?
                reject()
                return

            resolve(Utility.buildTooltipForFunction(value))
