Utility = require './Utility'

module.exports =
    ###*
     * Builds a tooltip for a classlike structural element.
     *
     * @param {Object} value
     *
     * @return {string}
    ###
    buildTooltipForClasslike: (value) ->
        description = ''

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

        # Shwo the FQCN.
        description += '<div class="section">'
        description +=     "<h4>Full Name</h4>"
        description +=     "<div>" + value.name + "</div>"
        description += "</div>"

        # Show the type.
        type = ''

        if value.type == 'class'
            type = (if value.isAbstract then 'Abstract ' else '') + 'Class'

        else if value.type == 'trait'
            type = 'Trait'

        else if value.type == 'interface'
            type = 'Interface'

        description += '<div class="section">'
        description +=     "<h4>Type</h4>"
        description +=     "<div>" + type + "</div>"
        description += "</div>"

        return description

    ###*
     * Builds a tooltip for a function.
     *
     * @param {Object} value
     *
     * @return {string}
    ###
    buildTooltipForFunction: (value) ->
        description = ""

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
            parametersDescription += '<tr>'

            parametersDescription += '<td class="php-integrator-tooltips-parameter-name">•&nbsp;'

            if param.isOptional
                parametersDescription += '['

            if param.isReference
                parametersDescription += '&'

            if param.isVariadic
                parametersDescription += '...'

            parametersDescription += '$' + param.name

            if param.isOptional
                parametersDescription += ']'

            parametersDescription += "</td>"

            parametersDescription += '<td class="php-integrator-tooltips-parameter-type">' + (if param.types.length > 0 then @buildTypeSpecificationFromTypeArray(param.types) else '&nbsp;') + '</td>'
            parametersDescription += '<td class="php-integrator-tooltips-parameter-description">' + (if param.description then param.description else '&nbsp;') + '</td>'

            parametersDescription += "</tr>"

        if parametersDescription.length > 0
            description += '<div class="section">'
            description +=     "<h4>Parameters</h4>"
            description +=     "<div><table>" + parametersDescription + "</table></div>"
            description += "</div>"

        returnValue = @buildTypeSpecificationFromTypeArray(value.returnTypes)

        returnDescription = ''

        if value.returnDescription
            returnDescription = ' &mdash; ' + value.returnDescription

        description += '<div class="section">'
        description +=     '<h4>Returns</h4>'
        description +=     '<div><span class="php-integrator-tooltips-return-type">' + returnValue + '</span>' + returnDescription + '</div>'
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
        # Create a useful description to show in the tooltip.
        description = ''

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

        returnDescription = ''

        if value.returnDescription
            returnDescription = ' &mdash; ' + value.returnDescription

        description += '<div class="section">'
        description +=     '<h4>Type</h4>'
        description +=     '<div><span class="php-integrator-tooltips-return-type">' + returnValue + '</span>' + returnDescription + '</div>'
        description += "</div>"

    ###*
     * Builds a tooltip for a constant.
     *
     * @param {Object} value
     *
     * @return {string}
    ###
    buildTooltipForConstant: (value) ->
        # Create a useful description to show in the tooltip.
        description = ''

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

        returnDescription = ''

        if value.returnDescription
            returnDescription = ' &mdash; ' + value.returnDescription

        description += '<div class="section">'
        description +=     '<h4>Type</h4>'
        description +=     '<div><span class="php-integrator-tooltips-return-type">' + returnValue + '</span>' + returnDescription + '</div>'
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
