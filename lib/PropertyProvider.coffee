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
                        value = classInfo.properties[name]

                        accessModifier = ''
                        returnType = if value.return?.type then value.return.type else 'mixed'

                        if value.isPublic
                            accessModifier = 'public'

                        else if value.isProtected
                            accessModifier = 'protected'

                        else
                            accessModifier = 'private'

                        # Create a useful description to show in the tooltip.
                        description = ''

                        description += "<p><div>"
                        description += accessModifier + ' ' + returnType + '<strong>' + ' $' + name + '</strong>'
                        description += '</div></p>'

                        # Show the summary (short description).
                        description += '<div>'
                        description +=     (if value.descriptions.short then value.descriptions.short else '(No documentation available)')
                        description += '</div>'

                        # Show the (long) description.
                        if value.descriptions.long?.length > 0
                            description += '<div class="section">'
                            description +=     "<h4>Description</h4>"
                            description +=     "<div>" + value.descriptions.long + "</div>"
                            description += "</div>"

                        if value.return?.type
                            returnValue = '<strong>' + value.return.type + '</strong>'

                            if value.return.description
                                returnValue += ' ' + value.return.description

                            description += '<div class="section">'
                            description +=     "<h4>Type</h4>"
                            description +=     "<div>" + returnValue + "</div>"
                            description += "</div>"

                        resolve(description)

                        return

                    reject()

                return @service.getClassInfo(className).then(successHandler, failureHandler)

            return @service.getResultingTypeAt(editor, bufferPosition, true).then(resultingTypeSuccessHandler, failureHandler)
