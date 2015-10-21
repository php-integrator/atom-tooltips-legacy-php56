{Disposable} = require 'atom'

ClassProvider   = require './class-provider.coffee'
FunctionProvider = require './function-provider.coffee'
PropertyProvider = require './property-provider.coffee'

module.exports =
    ###*
     * List of tooltip providers.
    ###
    providers: []

    ###*
     * Activates the package.
    ###
    activate: ->

    ###*
     * Deactivates the package.
    ###
    deactivate: ->
        @deactivateProviders()

    ###*
     * Activates the providers using the specified service.
    ###
    activateProviders: (service) ->
        @providers = []
        @providers.push new ClassProvider()

        # TODO: Rewrite these too.
        #@providers.push new FunctionProvider()
        #@providers.push new PropertyProvider()

        for provider in @providers
            provider.activate(service)

    ###*
     * Deactivates any active providers.
    ###
    deactivateProviders: () ->
        for provider in @providers
            provider.deactivate()

        @providers = []

    ###*
     * Sets the php-integrator service.
    ###
    setService: (service) ->
        @activateProviders(service)

        # TODO: Handle and test package deactivation.
        return new Disposable -> deactivateProviders()
