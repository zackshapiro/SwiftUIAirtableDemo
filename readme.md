# SwiftUI Airtable Demo

This is a small, functional example app that demonstrates how you can use Airtable as a lightweight backend. I wouldn't recommend using Airtable to store fast-moving data but as a means of storing strings, images, positions of views, and general data that won't get updated very often, Airtable could be a potential option for you.

Created by [Zack Shapiro](https://twitter.com/zackshapiro)

---

## Demo

Check out the [video demo](https://share.getcloudapp.com/bLue5z98) of this app.

---

### Our Airtable setup:

![](https://p93.f3.n0.cdn.getcloudapp.com/items/lluDdRYl/Screen%20Shot%202020-05-07%20at%201.19.00%20PM.png?v=e6b3e1a71d2acf4d2ab61e77b348fff5)

![](https://p93.f3.n0.cdn.getcloudapp.com/items/NQuDjRro/Screen%20Shot%202020-05-07%20at%201.19.06%20PM.png?v=1657ce26609a1f9c805b662d304cd92a)

### App Rendering:

![](https://p93.f3.n0.cdn.getcloudapp.com/items/2NuX7Jld/Simulator%20Screen%20Shot%20-%20iPhone%20SE%20%282nd%20generation%29%20-%202020-05-07%20at%2013.18.51.png?v=0935a755876eca8f21c5bed0c9bc3186)

![](https://p93.f3.n0.cdn.getcloudapp.com/items/BluZWjKm/Simulator%20Screen%20Shot%20-%20iPhone%20SE%20%282nd%20generation%29%20-%202020-05-07%20at%2013.18.57.png?v=e42b4b30c4fd5da17ccde5a61d7cf2d4)

---

## Running the app

1. Clone the repo and open the `.xcworkspace` file (You shouldn't need to run `pod install`).
2. Create your own Airtables and mimick the same column types and data as I have in the screenshots above.
3. **Important**: Visit https://airtable.com/api, choose your Base, and get the link to your base and API key. Plug those into `apiKey` and `apiBaseUrl` in [`AirtableService.swift`](https://github.com/zackshapiro/SwiftUIAirtableDemo/blob/master/SwiftUIAirtableDemo/Services/AirtableService.swift#L14).
4. Build and run the app.

## Requirements

Built using:

- Xcode 11.4.1
- Cocoapods
- [SwiftAirtable](https://github.com/nicolasnascimento/SwiftAirtable)
- SwiftUI
- Airtable

## Contributing

Feel free to contribute. Leave an Issue if there is one.

## License

[MIT](https://github.com/zackshapiro/SwiftUIAirtableDemo/blob/master/LICENSE)
