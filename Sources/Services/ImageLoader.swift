import UIKit

final class ImageLoader {
    static let shared = ImageLoader()

    private let cache = NSCache<NSURL, UIImage>()
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func load(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let nsUrl = url as NSURL
        if let cached = cache.object(forKey: nsUrl) {
            DispatchQueue.main.async { completion(cached) }
            return
        }

        session.dataTask(with: url) { [weak self] data, _, _ in
            let image = data.flatMap(UIImage.init(data:))
            if let image, let self {
                self.cache.setObject(image, forKey: nsUrl)
            }
            DispatchQueue.main.async { completion(image) }
        }.resume()
    }
}
