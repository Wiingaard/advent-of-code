#!/usr/bin/env swift

import Foundation

// MARK: - Session Cookie Configuration
// To refresh your session cookie:
// 1. Open Safari and go to https://adventofcode.com (make sure you're logged in)
// 2. Enable Developer menu: Safari → Settings → Advanced → Check "Show features for web developers"
// 3. Open Web Inspector: Safari → Develop → Show Web Inspector (Option + Command + I)
// 4. Go to Storage tab → Cookies → https://adventofcode.com
// 5. Find the "session" cookie and copy its Value
// 6. Replace the value below with your new session cookie
let SESSION_COOKIE = "53616c7465645f5fc134cad61dc9f0ff372b99c1b910e18cce8e30104ba08fbea3de59f8e290d91e4b3b2d95b8a914cf9b61f06c639238d61fa77765f1b83da6"

// MARK: - Main Function
func main() {
    // Parse command line arguments
    let arguments = CommandLine.arguments
    
    guard arguments.count == 2 else {
        print("Usage: swift download-input.swift <day>")
        print("Example: swift download-input.swift 1")
        exit(1)
    }
    
    guard let day = Int(arguments[1]), day >= 1, day <= 25 else {
        print("Error: Day must be a number between 1 and 25")
        exit(1)
    }
    
    // Construct URL
    let urlString = "https://adventofcode.com/2025/day/\(day)/input"
    guard let url = URL(string: urlString) else {
        print("Error: Invalid URL: \(urlString)")
        exit(1)
    }
    
    // Create request with session cookie
    var request = URLRequest(url: url)
    request.setValue("session=\(SESSION_COOKIE)", forHTTPHeaderField: "Cookie")
    request.setValue("https://adventofcode.com", forHTTPHeaderField: "Referer")
    
    // Perform download
    let semaphore = DispatchSemaphore(value: 0)
    var downloadError: Error?
    var responseData: Data?
    var httpResponse: HTTPURLResponse?
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            downloadError = error
        } else if let httpResp = response as? HTTPURLResponse {
            httpResponse = httpResp
            if httpResp.statusCode == 200 {
                responseData = data
            } else {
                downloadError = NSError(
                    domain: "AOCDownloader",
                    code: httpResp.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResp.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpResp.statusCode))"]
                )
            }
        }
        semaphore.signal()
    }
    
    task.resume()
    semaphore.wait()
    
    // Handle errors
    if let error = downloadError {
        print("Error downloading input: \(error.localizedDescription)")
        if let httpResp = httpResponse {
            print("HTTP Status: \(httpResp.statusCode)")
            if httpResp.statusCode == 404 {
                print("Hint: The puzzle for day \(day) may not be available yet.")
            } else if httpResp.statusCode == 401 || httpResp.statusCode == 403 {
                print("Hint: Your session cookie may have expired. Please refresh it.")
            }
        }
        exit(1)
    }
    
    guard let data = responseData else {
        print("Error: No data received")
        exit(1)
    }
    
    // Write to file
    let filename = String(format: "day%02d.txt", day)
    let fileURL = URL(fileURLWithPath: filename)
    
    do {
        try data.write(to: fileURL)
        print("Successfully downloaded input for day \(day) to \(filename)")
    } catch {
        print("Error writing file: \(error.localizedDescription)")
        exit(1)
    }
}

main()
