Utility = require './Utility'
AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides tooltips for member methods.
##
class MethodProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    hoverEventSelectors: '.function-call.object, .function-call.static'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        try
            value = @service.getClassMemberAt(editor, bufferPosition, name)

        catch error
            return

        return unless value

        return Utility.buildTooltipForFunction(value)
