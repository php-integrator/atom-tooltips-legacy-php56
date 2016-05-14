Utility = require './Utility'

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

        if value.returnTypes.length > 0
            returnType = @buildTypeSpecificationFromTypeArray(value.returnTypes)

        if value.isPublic
            accessModifier = 'public '

        else if value.isProtected
            accessModifier = 'protected '

        else if value.isPrivate
            accessModifier = 'private '

        description += "<p><div>"

        # Show the signature.
        description += accessModifier + returnType + ' <strong>' + value.name + '</strong>' + '('

        isFirst = true
        isInOptionalList = false

        for param, index in value.parameters
            description += '['  if param.isOptional and not isInOptionalList
            description += ', ' if not isFirst
            description += '&'   if param.isReference
            description += '$' + param.name
            description += '...' if param.isVariadic
            description += ']'   if param.isOptional and index == (value.parameters.length - 1)

            isFirst = false
            isInOptionalList = param.isOptional

        description += ')'
        description += '</div></p>'

        # Show the summary (short description).
        description += '<div>'
        description +=     (if value.shortDescription then value.shortDescription else '(No documentation available)')
        description += '</div>'

        # Show the (long) description.
        if value.longDescription?.length > 0
            description += '<div class="section">'
            description +=     "<h4>Description</h4>"
            description +=     "<div>" + value.longDescription + "</div>"
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

            if param.isVariadic
                parametersDescription += '...'

            parametersDescription += '$' + param.name

            if param.isOptional
                parametersDescription += ']'

            parametersDescription += "</strong></td>"

            parametersDescription += "<td>" + (if param.types.length > 0 then @buildTypeSpecificationFromTypeArray(param.types) else '&nbsp;') + '</td>'
            parametersDescription += "<td>" + (if param.description then param.description else '&nbsp;') + '</td>'

            parametersDescription += "</tr>"

        if parametersDescription.length > 0
            description += '<div class="section">'
            description +=     "<h4>Parameters</h4>"
            description +=     "<div><table>" + parametersDescription + "</table></div>"
            description += "</div>"

        returnValue = @buildTypeSpecificationFromTypeArray(value.returnTypes)

        if value.returnDescription
            returnValue += ' &mdash; ' + value.returnDescription

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

    ###*
     * Builds a tooltip for a property.
     *
     * @param {Object} value
     *
     * @return {string}
    ###
    buildTooltipForProperty: (value) ->
        accessModifier = ''
        returnType = ''

        if value.types.length > 0
            returnType = @buildTypeSpecificationFromTypeArray(value.types)

        if value.isPublic
            accessModifier = 'public'

        else if value.isProtected
            accessModifier = 'protected'

        else
            accessModifier = 'private'

        # Create a useful description to show in the tooltip.
        description = ''

        description += "<p><div>"
        description += accessModifier + ' ' + returnType + '<strong>' + ' $' + value.name + '</strong>'
        description += '</div></p>'

        # Show the summary (short description).
        description += '<div>'
        description +=     (if value.shortDescription then value.shortDescription else '(No documentation available)')
        description += '</div>'

        # Show the (long) description.
        if value.longDescription?.length > 0
            description += '<div class="section">'
            description +=     "<h4>Description</h4>"
            description +=     "<div>" + value.longDescription + "</div>"
            description += "</div>"

        returnValue = @buildTypeSpecificationFromTypeArray(value.types)

        if value.typeDescription
            returnValue += ' &mdash; ' + value.typeDescription

        description += '<div class="section">'
        description +=     "<h4>Type</h4>"
        description +=     "<div>" + returnValue + "</div>"
        description += "</div>"

    ###*
     * Builds a tooltip for a constant.
     *
     * @param {Object} value
     *
     * @return {string}
    ###
    buildTooltipForConstant: (value) ->
        returnType = ''

        if value.types.length > 0
            returnType = @buildTypeSpecificationFromTypeArray(value.types)

        # Create a useful description to show in the tooltip.
        description = ''

        description += "<p><div>"
        description += 'const ' + returnType + '<strong>' + ' ' + value.name + '</strong>'
        description += '</div></p>'

        # Show the summary (short description).
        description += '<div>'
        description +=     (if value.shortDescription then value.shortDescription else '(No documentation available)')
        description += '</div>'

        # Show the (long) description.
        if value.longDescription?.length > 0
            description += '<div class="section">'
            description +=     "<h4>Description</h4>"
            description +=     "<div>" + value.longDescription + "</div>"
            description += "</div>"

        returnValue = @buildTypeSpecificationFromTypeArray(value.types)

        if value.typeDescription
            returnValue += ' &mdash; ' + value.typeDescription

        description += '<div class="section">'
        description +=     "<h4>Type</h4>"
        description +=     "<div>" + returnValue + "</div>"
        description += "</div>"

        return description

    ###*
     * @param {Array} typeArray
     *
     * @return {String}
    ###
    buildTypeSpecificationFromTypeArray: (typeArray) ->
        if typeArray.length == 0
            return '(Not known)'

        typeNames = typeArray.map (type) ->
            return type.type

        return typeNames.join('|')
