Utility = require './Utility'
AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides tooltips for member properties.
##
class PropertyProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    hoverEventSelectors: '.property'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            failureHandler = () =>
                reject()

            resultingTypeSuccessHandler = (className) =>
                if not className?
                    reject()
                    return

                successHandler = (classInfo) =>
                    if name of classInfo.properties
                        tooltipText = Utility.buildTooltipForProperty(classInfo.properties[name])

                        resolve(tooltipText)
                        return

                    reject()

                return @service.getClassInfo(className).then(successHandler, failureHandler)

            return @service.getResultingTypeAt(editor, bufferPosition, true).then(resultingTypeSuccessHandler, failureHandler)
