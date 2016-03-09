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
                className = @service.getResultingTypeAt(editor, bufferPosition, true)

            catch error
                reject()
                return

            successHandler = (classInfo) =>
                if name of classInfo.constants
                    tooltipText = Utility.buildTooltipForConstant(classInfo.constants[name])

                    resolve(tooltipText)
                    return

                reject()

            failureHandler = () =>
                reject()

            return @service.getClassInfo(className, true).then(successHandler, failureHandler) 
