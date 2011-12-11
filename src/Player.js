// Import the cocos2d module
var cocos = require('cocos2d'),
// Import the geometry module
    geo = require('geometry'),
    util = require('util');

var Config = require('config').Config;

var Player = cocos.nodes.Node.extend(
{
    init: function() 
    {
        Player.superclass.init.call( this );

        var image;
        if ( Math.random() < 0.5 )
            image = '/resources/player1.png';
        else 
            image = '/resources/player2.png';

        this.set( 'contentSize', new geo.Size( 64, 64 ) );
        var sprite = cocos.nodes.Sprite.create(
            {
                         file: image,
                         rect: new geo.Rect( 0, 0, 64, 64 )
            }
        );

        sprite.set( 'anchorPoint', new geo.Point( 0, 0 ) );
        this.addChild( { child: sprite } );

        this.set( 'velocity', new geo.Point( 0, 0 ) );
        this.set( 'acceleration', new geo.Point( 0, Config.player.fallAcceleration ) );

        this.set( 'isJumping', false );
        
        this.scheduleUpdate();
    },

    update: function( deltaTime )
    {
        var acceleration = util.copy( this.get( 'acceleration' ) ),
            position = util.copy( this.get( 'position' ) ),
            velocity = util.copy( this.get( 'velocity' ) );

        if ( this.get( 'isJumping') == true )
        {
            velocity.y = Config.player.jumpingVelocity; 
            if ( !Config.player.holdJump )
            {
                this.set( 'isJumping', false );
            }           
        }

        velocity.x += acceleration.x * deltaTime;
        velocity.y += acceleration.y * deltaTime;

        this.set( 'velocity', velocity );
        position.x += velocity.x * deltaTime;
        position.y += velocity.y * deltaTime;
        this.set( 'position', position );

        this.testEdgeCollision();
    },

    testEdgeCollision : function()
    {
        var position = util.copy( this.get( 'position' ) ),
            velocity = util.copy( this.get('velocity') ),
            boundingBox = this.get('boundingBox'),
            anchorPoint = util.copy( this.get( 'anchorPointInPixels' ) ),
            // Get size of canvas
            windowSize = cocos.Director.get('sharedDirector').get('winSize');

        if ( geo.rectGetMinY( boundingBox ) <= 0 )
        {
            velocity.y = 0;
            position.y = anchorPoint.y;
        } else if ( geo.rectGetMaxY( boundingBox ) >= windowSize.height )
        {
            velocity.y = -velocity.y * Config.player.bounceRate;
            position.y = windowSize.height - anchorPoint.y;
        }

        this.set( 'position', position );
        this.set( 'velocity', velocity );    
    },

    setJumping : function( value )
    {
        this.set( 'isJumping', value );
    }
} );

module.exports = Player;
