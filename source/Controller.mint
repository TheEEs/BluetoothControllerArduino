component Controller {
  property deviceID : String

  state leftForce : Number = 0
  state rightForce : Number = 0

  connect Application exposing {setPage}

  style level {

  }

  style panels {
    position: absolute;
    display: flex;
    bottom: 0;
    top: 125px;
    left: 0;
    right: 0;
    z-index: -1;
  }

  style panel {
      position: relative;
      width: 50vw;
  }

  fun disconnect {
      sequence {
          id = deviceID
          disconnected = `
          new Promise((resolve,reject)=>{
              bluetoothSerial.disconnect(function(){
                  resolve(#{id});
              }, function(){
                  reject(#{id});
              });
          })
          `
          disconnectedDevice = decode disconnected as String
          `Capacitor.Plugins.Toast.show({text : "Successfully disconnected from " + #{disconnectedDevice}})`
          setPage(Page::Device)
      }
      catch  {
            setPage(Page::Device)  
      }
  }

  fun render : Array(Html) {
    [
      <div::level class="level pb-1 pt-1 is-mobile has-background-primary">
        <div class="level-left">
          <div class="container" onClick={disconnect}>
            <button class="button is-primary is-inverted is-small ml-3" onclick={disconnect}>
                <span class="icon is-small">
                    <i class="fas fa-long-arrow-alt-left"></i>
                </span>
                <{ "Quay lại" }>
            </button>
          </div>
        </div>

        <div class="level-right">
          <h1 class="subtitle has-text-white level-item is-size-7 mr-3">
            "ID thiết bị: "
            <{ deviceID }>
          </h1>
        </div>
      </div>,
      <div::panels>
        <div::panel id="left">
            
        </div>
        <div::panel id="right">
            
        </div>
      </div>
    ]
  }

  fun joystickMoveHandler(side : String, force : Number){
    sequence {
        case (side){
            "left" => next {leftForce = Math.clamp(0,255,force * 100)}
            "right" => next {rightForce = Math.clamp(0,255,force * 100)}
            => Promise.never()
        }   
        `bluetoothSerial.write([parseInt(#{leftForce}), parseInt(#{rightForce})])`
    }
  }

  fun componentDidMount {
      sequence {
           handler = joystickMoveHandler
            leftManager = (`nipplejs.create({
                zone : document.getElementById("left") ,
                color: "#16a085",
                lockY: true,
                multitouch: false
            })`)
            `#{leftManager}.on("move",function(event,data){
                #{handler}("left",data.force)
            })`
            `#{leftManager}.on("end",function(){
                #{handler}("left",0)
            })`
            rightManager = (`nipplejs.create({
                zone : document.getElementById("right") ,
                color: "#16a085",
                lockY: true,
                multitouch: false
            })`)
            `#{rightManager}.on("move",function(event,data){
                #{handler}("right",data.force)
            })`
            `#{rightManager}.on("end",function(){
                #{handler}("right",0)
            })`
      }
  }
}
