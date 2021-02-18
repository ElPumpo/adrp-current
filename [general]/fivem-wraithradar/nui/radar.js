/*-------------------------------------------------------------------------

    Wraith Radar System - v1.01
    Created by WolfKnight
    
-------------------------------------------------------------------------*/

var resourceName = ""; 
var radarEnabled = false; 
var targets = []; 

$( function() {
    radarInit();

    var radarContainer = $( "#policeradar" );

    var fwdArrowFront = radarContainer.find( ".fwdarrowfront" );
    var fwdArrowBack = radarContainer.find( ".fwdarrowback" );
    var bwdArrowFront = radarContainer.find( ".bwdarrowfront" );
    var bwdArrowBack = radarContainer.find( ".bwdarrowback" );

    var fwdSame = radarContainer.find( ".fwdsame" );
    var fwdOpp = radarContainer.find( ".fwdopp" );
    var fwdXmit = radarContainer.find( ".fwdxmit" );

    var bwdSame = radarContainer.find( ".bwdsame" );
    var bwdOpp = radarContainer.find( ".bwdopp" );
    var bwdXmit = radarContainer.find( ".bwdxmit" );

    var radarRCContainer = $( "#policeradarrc" ); 

    window.addEventListener( 'message', function( event ) {
        var item = event.data;

        if ( item.resourcename ) {
            resourceName = item.resourcename;
        }

        if ( item.toggleradar ) {
            radarEnabled = !radarEnabled; 
            radarContainer.fadeToggle();
        }

        if ( item.hideradar ) {
            radarContainer.fadeOut();
        } else if ( item.hideradar == false ) {
            radarContainer.fadeIn();
        }

        // if ( item.patrolspeed ) {
        //     updateSpeed( "patrolspeed", item.patrolspeed ); 
        // }

        if ( item.fwdspeed ) {
            updateSpeed( "fwdspeed", item.fwdspeed ); 
        }

        if ( item.fwdfast ) {
            updateSpeed( "fwdfast", item.fwdfast ); 
        }

        if ( item.lockfwdfast == true || item.lockfwdfast == false ) {
            lockSpeed( "fwdfast", item.lockfwdfast )
        }

        if ( item.bwdspeed ) {
            updateSpeed( "bwdspeed", item.bwdspeed );  
        }

        if ( item.bwdfast ) {
            updateSpeed( "bwdfast", item.bwdfast );    
        }

        if ( item.lockbwdfast == true || item.lockbwdfast == false ) {
            lockSpeed( "bwdfast", item.lockbwdfast )
        }

        if ( item.fwddir || item.fwddir == false || item.fwddir == null ) {
            updateArrowDir( fwdArrowFront, fwdArrowBack, item.fwddir )
        }

        if ( item.bwddir || item.bwddir == false || item.bwddir == null ) {
            updateArrowDir( bwdArrowFront, bwdArrowBack, item.bwddir )
        }

        if ( item.fwdxmit ) {
            fwdXmit.addClass( "active" );
        } else if ( item.fwdxmit == false ) {
            fwdXmit.removeClass( "active" );
        }

        if ( item.bwdxmit ) {
            bwdXmit.addClass( "active" );   
        } else if ( item.bwdxmit == false ) {
            bwdXmit.removeClass( "active" );   
        }

        if ( item.fwdmode ) {
            modeSwitch( fwdSame, fwdOpp, item.fwdmode );
        }

        if ( item.bwdmode ) {
            modeSwitch( bwdSame, bwdOpp, item.bwdmode );
        }

        if ( item.toggleradarrc ) {
            radarRCContainer.toggle();
        }

        if (item.reset) {
            reset(document.getElementById("policeradar"))
        }

    } );
        var e = window.event || e;
        var height = screen.height;
        var width = screen.width;
        draggable(document.getElementById("policeradar"));

      function addListener(element, type, callback, capture) {
        if (element.addEventListener) {
          element.addEventListener(type, callback, capture);
        } else {
          element.attachEvent("on" + type, callback);
        }
      }

      function reset(element) {
        element.style.top =  0 + "px";
        element.style.left = 0 + "px";
      }



      function draggable(element) {
        var dragging = null;
        var reset = null

        addListener(element, "mousedown", function(e) {
          dragging = {
            mouseX: e.clientX,
            mouseY: e.clientY,
            startX: parseInt(element.style.left),
            startY: parseInt(element.style.top)
          };
          if (element.setCapture) element.setCapture();
        });

        addListener(element, "losecapture", function() {
          dragging = null;
        });

        addListener(document, "mouseup", function() {
          dragging = null;
          if (document.releaseCapture) document.releaseCapture();
        }, true);

        var dragTarget = element.setCapture ? element : document;

        addListener(dragTarget, "mousemove", function(e) {
          if (!dragging) return;

          var top = dragging.startY + (e.clientY - dragging.mouseY);
          var left = dragging.startX + (e.clientX - dragging.mouseX);

          element.style.top = (Math.max(0, top)) + "px";
          element.style.left = (Math.max(0, left)) + "px";
        }, true);
      }
} )

function radarInit() {
    $( '.container' ).each( function( i, obj ) {
        $( this ).find( '[data-target]' ).each( function( subi, subobj ) {
            targets[ $( this ).attr( "data-target" ) ] = $( this )
        } )
     } );

    $( "#policeradarrc" ).find( "button" ).each( function( i, obj ) {
        if ( $( this ).attr( "data-action" ) ) {
            $( this ).click( function() { 
                var data = $( this ).data( "action" ); 

                sendData( "RadarRC", data ); 
            } )
        }
    } );
}

function updateSpeed( attr, data ) {
    targets[ attr ].find( ".speednumber" ).each( function( i, obj ) {
        $( obj ).html( data[i] ); 
    } ); 
}

function lockSpeed( attr, state ) {
    targets[ attr ].find( ".speednumber" ).each( function( i, obj ) {
        if ( state == true ) {
            $( obj ).addClass( "locked" ); 
        } else {
            $( obj ).removeClass( "locked" );
        }
    } ); 
}

function modeSwitch( sameEle, oppEle, state ) {
    if ( state == "same" ) {
        sameEle.addClass( "active" );
        oppEle.removeClass( "active" ); 
    } else if ( state == "opp" ) {
        oppEle.addClass( "active" );
        sameEle.removeClass( "active" ); 
    } else if ( state == "none" ) {
        oppEle.removeClass( "active" ); 
        sameEle.removeClass( "active" ); 
    }
}

function updateArrowDir( fwdEle, bwdEle, state ) {
    if ( state == true ) {
        fwdEle.addClass( "active" ); 
        bwdEle.removeClass( "active" ); 
    } else if ( state == false ) {
        bwdEle.addClass( "active" ); 
        fwdEle.removeClass( "active" ); 
    } else if ( state == null ) {
        fwdEle.removeClass( "active" ); 
        bwdEle.removeClass( "active" ); 
    }
}

function sendData( name, data ) {
    $.post( "http://" + resourceName + "/" + name, JSON.stringify( data ), function( datab ) {
        if ( datab != "ok" ) {
            console.log( datab );
        }            
    } );
}