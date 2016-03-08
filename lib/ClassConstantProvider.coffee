Utility = require './Utility'
AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides tooltips for member constants.
##
class ClassConstantProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    hoverEventSelectors: '.constant.other.class'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            try
                value = @service.getClassConstantAt(editor, bufferPosition, name)

            catch error
                reject()
                return

            if not value?
                reject()
                return

            resolve(Utility.buildTooltipForConstant(value))
