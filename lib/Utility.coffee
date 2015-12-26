
module.exports =
    ###*
     * Builds a tooltip for a function.
     *
     * @param {Object} value
     *
     * @return {string}
    ###
    buildTooltipForFunction: (value) ->
        description = ""

        # Show the method's signature.
        accessModifier = ''
        returnType = ''

        if value.return?.type
            returnType = value.return.type

        if value.isPublic
            accessModifier = 'public '

        else if value.isProtected
            accessModifier = 'protected '

        else if value.isPrivate
            accessModifier = 'private '

        description += "<p><div>"
        description += accessModifier + returnType + ' <strong>' + value.name + '</strong>' + '('

        isFirst = true

        for param in value.parameters
            if param.isOptional
                description += '['

            if not isFirst
                description += ', '

            if param.isReference
                description += '&'

            description += '$' + param.name

            if param.isVariadic
                description += '...'

            if param.isOptional
                description += ']'

            isFirst = false

        description += ')'
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

        # Show the parameters the method has.
        parametersDescription = ""

        for param in value.parameters
            parametersDescription += "<tr>"

            parametersDescription += "<td>•&nbsp;<strong>"

            if param.isOptional
                parametersDescription += '['

            if param.isReference
                parametersDescription += '&'

            parametersDescription += '$' + param.name

            if param.isVariadic
                parametersDescription += '...' + param.name

            if param.isOptional
                parametersDescription += ']'

            parametersDescription += "</strong></td>"

            parametersDescription += "<td>" + (if param.type then param.type else '&nbsp;') + '</td>'
            parametersDescription += "<td>" + (if param.description then param.description else '&nbsp;') + '</td>'

            parametersDescription += "</tr>"

        if parametersDescription.length > 0
            description += '<div class="section">'
            description +=     "<h4>Parameters</h4>"
            description +=     "<div><table>" + parametersDescription + "</table></div>"
            description += "</div>"

        if value.return?.type
            returnValue = '<strong>' + value.return.type + '</strong>'

            if value.return.description
                returnValue += ' ' + value.return.description

            description += '<div class="section">'
            description +=     "<h4>Returns</h4>"
            description +=     "<div>" + returnValue + "</div>"
            description += "</div>"

        # Show an overview of the exceptions the method can throw.
        throwsDescription = ""

        for exceptionType,thrownWhenDescription of value.throws
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
