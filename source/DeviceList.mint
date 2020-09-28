component DeviceList {
  property devices : Array(Device)

  connect Application exposing { setPage }

  fun connectToDevice (event : Html.Event) {
    sequence {
      event
      |> Html.Event.stopPropagation()

      `
            new Promise(function(resolve,reject){
                bluetoothSerial.disconnect(function(){
                    resolve()
                },function(){
                    reject()
                })
            })
            `

      deviceID =
        encode (event.target
        |> Dom.getAttribute("id"))

      `console.log("connecting to " + #{deviceID})`

      connection =
        (`
            new Promise(function(resolve,reject){
                bluetoothSerial.connect(#{deviceID},function(){
                    resolve(#{deviceID})
                },function(){
                    reject(#{deviceID})
                })
            })
            `)

      decodedConnection =
        decode connection as String

      setPage(Page::Controller(decodedConnection))

      `Capacitor.Plugins.Toast.show({text : "Connected to " + #{decodedConnection}})`
    } catch Object.Error => e {
      Result.error(e)
    }
  }

  fun connect {
    setPage(Page::Controller("123213"))
  }

  fun render : Array(Html) {
    [
      <section class="hero is-primary">
        <div class="hero-body">
          <div class="container">
            <h1 class="title">
              "Thiết bị"
            </h1>

            <h2 class="subtitle is-6">
              "Lựa chọn thiết bị bạn muốn kết nối"
            </h2>
          </div>
        </div>
      </section>,
      if (Array.size(devices) == 0) {
        <div
          onClick={connect}
          class="notification is-warning">

          "Chưa có thiết bị nào được kết nối. Thử kiểm tra lại cài đặt bluetooth"

        </div>
      } else {
        <{ "" }>
      },
      <section class="container section">
        <section class="columns container">
          for (device of devices) {
            <div class="column">
              <div
                class="box content"
                id={device.address}
                onClick={connectToDevice}>

                <h1 class="title is-5">
                  "#{device.name}"
                </h1>

                <p>"#{device.address}"</p>

              </div>
            </div>
          }
        </section>
      </section>
    ]
  }
}
