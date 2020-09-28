record Device {
  class : Number,
  id : String,
  address : String,
  name : String
}

component Main {
  state devices : Array(Device) = []

  connect Application exposing { page }

  style base {
    font-family: sans;
    font-weight: bold;
    font-size: 50px;

    justify-content: center;
    align-items: center;
    display: flex;
    height: 100vh;
    width: 100vw;
  }

  fun render : Html {
    case (page) {
      Page::Device => <DeviceList devices={devices}/>
      Page::Controller deviceID => <Controller deviceID={deviceID}/>
    }
  }

  fun componentDidMount {
    sequence {
      devices =
        `new Promise(function(resolve,reject){
        bluetoothSerial.list(function(devs){
          resolve(devs);
        }, function(){
          reject();
        });
      })`

      decodedDevices =
        decode devices as Array(Device)

      next { devices = decodedDevices }
    } catch Object.Error => e {
      Promise.never()
    }
  }
}
