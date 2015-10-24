AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides tooltips for member methods.
##
class MethodProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    hoverEventSelectors: '.function-call'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        value = @service.getClassMemberAt(editor, bufferPosition, name)

        return unless value

        description = ""

        # Show the method's signature.
        accessModifier = ''
        returnType = (if value.args.return then value.args.return else '')

        if value.isPublic
            accessModifier = 'public'

        else if value.isProtected
            accessModifier = 'protected'

        else
            accessModifier = 'private'

        description += "<p><div>"
        description += accessModifier + ' ' + returnType + ' <strong>' + name + '</strong>' + '('

        if value.args.parameters.length > 0
            description += value.args.parameters.join(', ');

        if value.args.optionals.length > 0
            description += '['

            if value.args.parameters.length > 0
                description += ', '

            description += value.args.optionals.join(', ')
            description += ']'

        description += ')'
        description += '</div></p>'

        # Show the summary (short description).
        description += '<div>'
        description +=     (if value.args.descriptions.short then value.args.descriptions.short else '(No documentation available)')
        description += '</div>'

        # Show the (long) description.
        if value.args.descriptions.long?.length > 0
            description += '<div class="section">'
            description +=     "<h4>Description</h4>"
            description +=     "<div>" + value.args.descriptions.long + "</div>"
            description += "</div>"

        # Show the parameters the method has.
        parametersDescription = ""

        for param in value.args.parameters
            parametersDescription += "<div>"
            parametersDescription += "• <strong>" + param + "</strong>"
            parametersDescription += "</div>"

        for param in value.args.optionals
            parametersDescription += "<div>"
            parametersDescription += "• <strong>[" + param + "]</strong>"
            parametersDescription += "</div>"

        if value.args.parameters.length > 0 or value.args.optionals.length > 0
            description += '<div class="section">'
            description +=     "<h4>Parameters</h4>"
            description +=     "<div>" + parametersDescription + "</div>"
            description += "</div>"

        if value.args.return
            description += '<div class="section">'
            description +=     "<h4>Returns</h4>"
            description +=     "<div>" + value.args.return + "</div>"
            description += "</div>"

        # Show an overview of the exceptions the method can throw.
        throwsDescription = ""

        for exceptionType,thrownWhenDescription of value.args.throws
            throwsDescription += "<div>"
            throwsDescription += "• <strong>" + exceptionType + "</strong>"

            if thrownWhenDescription
                throwsDescription += ' ' + thrownWhenDescription

            throwsDescription += "</div>"

        if throwsDescription.length > 0
            description += '<div class="section">'
            description +=     "<h4>Throws</h4>"
            description +=     "<div>" + throwsDescription + "</div>"
            description += "</div>"

        return description
