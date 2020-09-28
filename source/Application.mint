enum Page {
  Device
  Controller(String)
}

store Application {
  state connected = false
  state page = Page::Device

  fun setPage (pageName : Page) {
    next { page = pageName }
  }
}
