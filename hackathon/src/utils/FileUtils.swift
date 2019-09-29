import Foundation

func getNewFileURL() -> URL {
    return FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
}
