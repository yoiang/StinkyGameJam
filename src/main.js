var cocos = require('cocos2d');
var geo =   require('geometry');
var Player = require('Player');
var EventDispatcher = require('cocos2d/EventDispatcher').EventDispatcher;

// Create a new layer
var StinkyGameJam = cocos.nodes.Layer.extend(
{
    init: function() 
    {
        // You must always call the super class version of init
        StinkyGameJam.superclass.init.call(this);

        

        // Get size of canvas
        var windowSize = cocos.Director.get('sharedDirector').get('winSize');

        // Create label
        var label = cocos.nodes.Label.create({string: 'Stinky', fontName: 'Arial', fontSize: 10});

        // Add label to layer
        this.addChild( { child: label, z:1 } );

        // Position the label in the centre of the view
        label.set('position', geo.ccp( windowSize.width / 2, 5 ) );

        var player = Player.create();
        this.addChild( { child: player } );
        player.set( 'position', new geo.Point( 50, windowSize.height / 2 ) );
        this.set( 'player', player );

        EventDispatcher.get( 'sharedDispatcher' ).addKeyboardDelegate( { delegate: this, priority: 0 } );

        this.scheduleUpdate();
    },

    update : function( deltaTime )
    {
    },

    keyDown : function( event )
    {
        this.get( 'player' ).setJumping( true );
    },

    keyUp : function( event )
    {
        this.get( 'player' ).setJumping( false );
    },
});

exports.main = function() {
    // Initialise application

    // Get director
    var director = cocos.Director.get('sharedDirector');

    // Attach director to our <div> element
    director.attachInView(document.getElementById('stinky_game_jam_app'));

    // Create a scene
    var scene = cocos.nodes.Scene.create();

    game = StinkyGameJam.create();
    // Add our layer to the scene
    scene.addChild( { child: game } );

    // Run the scene
    director.runWithScene( scene );
};
