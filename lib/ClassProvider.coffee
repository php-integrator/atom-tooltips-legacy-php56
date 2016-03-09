$ = require 'jquery'

AbstractProvider = require './AbstractProvider'

module.exports =

##*
# Provides tooltips for classes, traits, interfaces, ...
##
class ClassProvider extends AbstractProvider
    ###*
     * @inheritdoc
    ###
    hoverEventSelectors: '.entity.name.type.class, .entity.inherited-class, .support.namespace, .support.class'

    ###*
     * @inheritdoc
    ###
    getTooltipForWord: (editor, bufferPosition, name) ->
        return new Promise (resolve, reject) =>
            scopeChain = editor.scopeDescriptorForBufferPosition(bufferPosition).getScopeChain()

            failureHandler = () =>
                reject()

            successHandler = (currentClassName) =>
                # Don't attempt to resolve class names in use statements. Note that scope descriptors for trait use
                # statements and actual "import" use statements are the same, so we have no choice but to use class
                # information for this: if we are inside a class, we can't be looking at a use statement.
                if scopeChain.indexOf('.support.other.namespace.use') == -1 or currentClassName?
                    try
                        name = @service.resolveTypeAt(editor, bufferPosition, name)

                    catch error
                        reject()
                        return

                successHandler = (classInfo) =>
                    type = ''

                    if classInfo.type == 'class'
                        type = (if classInfo.isAbstract then 'abstract ' else '') + 'class'

                    else if classInfo.type == 'trait'
                        type = 'trait'

                    else if classInfo.type == 'interface'
                        type = 'interface'

                    # Create a useful description to show in the tooltip.
                    description = ''

                    description += "<p><div>"
                    description +=     type + ' ' + '<strong>' + classInfo.shortName + '</strong> &mdash; ' + classInfo.name
                    description += '</div></p>'

                    # Show the summary (short description).
                    description += '<div>'
                    description +=     (if classInfo.descriptions.short then classInfo.descriptions.short else '(No documentation available)')
                    description += '</div>'

                    # Show the (long) description.
                    if classInfo.descriptions.long?.length > 0
                        description += '<div class="section">'
                        description +=     "<h4>Description</h4>"
                        description +=     "<div>" + classInfo.descriptions.long + "</div>"
                        description += "</div>"

                    resolve(description)

                return @service.getClassInfo(name, true).then(successHandler, failureHandler)

            return @service.determineCurrentClassName(editor, bufferPosition, true).then(successHandler, failureHandler)

    ###*
     * @inheritdoc
    ###
    getSelectorFromEvent: (event) ->
        return @service.getClassSelectorFromEvent(event)

    ###*
     * @inheritdoc
    ###
    getPopoverElementFromSelector: (selector) ->
        # getSelectorFromEvent can return multiple items because namespaces and class names are different HTML elements.
        # We have to select one to attach the popover to.
        array = $(selector).toArray()
        return array[array.length - 1]
