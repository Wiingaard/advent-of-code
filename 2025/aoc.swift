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

// MARK: - Helper Functions

func createAuthenticatedRequest(url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.setValue("session=\(SESSION_COOKIE)", forHTTPHeaderField: "Cookie")
    request.setValue("https://adventofcode.com", forHTTPHeaderField: "Referer")
    return request
}

func performRequest(_ request: URLRequest) -> (Data?, HTTPURLResponse?, Error?) {
    let semaphore = DispatchSemaphore(value: 0)
    var responseData: Data?
    var httpResponse: HTTPURLResponse?
    var requestError: Error?
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            requestError = error
        } else if let httpResp = response as? HTTPURLResponse {
            httpResponse = httpResp
            if httpResp.statusCode == 200 {
                responseData = data
            } else {
                requestError = NSError(
                    domain: "AOCScript",
                    code: httpResp.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResp.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpResp.statusCode))"]
                )
            }
        }
        semaphore.signal()
    }
    
    task.resume()
    semaphore.wait()
    
    return (responseData, httpResponse, requestError)
}

func extractCSRFToken(from html: String) -> String? {
    // Look for the CSRF token in the HTML (usually in a hidden input or meta tag)
    // Pattern: <input type="hidden" name="csrf_token" value="...">
    // Or: name="_token" value="..."
    let patterns = [
        "name=\"_token\" value=\"([^\"]+)\"",
        "name=\"csrf_token\" value=\"([^\"]+)\"",
        "csrf-token\" content=\"([^\"]+)\""
    ]
    
    let nsString = html as NSString
    for pattern in patterns {
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(location: 0, length: nsString.length)
            if let match = regex.firstMatch(in: html, options: [], range: range),
               match.numberOfRanges > 1 {
                let tokenRange = match.range(at: 1)
                return nsString.substring(with: tokenRange)
            }
        }
    }
    
    return nil
}

// MARK: - Commands

func downloadPuzzle(day: Int) {
    let urlString = "https://adventofcode.com/2025/day/\(day)"
    guard let url = URL(string: urlString) else {
        print("Error: Invalid URL: \(urlString)")
        exit(1)
    }
    
    let request = createAuthenticatedRequest(url: url)
    let (data, httpResponse, error) = performRequest(request)
    
    if let error = error {
        print("Error downloading puzzle: \(error.localizedDescription)")
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
    
    guard let htmlData = data else {
        print("Error: No data received")
        exit(1)
    }
    
    // Save HTML file
    let filename = String(format: "day%02d.html", day)
    let fileURL = URL(fileURLWithPath: filename)
    
    do {
        try htmlData.write(to: fileURL)
        print("Successfully downloaded puzzle for day \(day) to \(filename)")
    } catch {
        print("Error writing file: \(error.localizedDescription)")
        exit(1)
    }
}

func submitAnswer(day: Int, level: Int, answer: String) {
    // First, fetch the puzzle page to get the CSRF token
    let puzzleURLString = "https://adventofcode.com/2025/day/\(day)"
    guard let puzzleURL = URL(string: puzzleURLString) else {
        print("Error: Invalid URL: \(puzzleURLString)")
        exit(1)
    }
    
    let puzzleRequest = createAuthenticatedRequest(url: puzzleURL)
    let (htmlData, _, error) = performRequest(puzzleRequest)
    
    guard let htmlData = htmlData, let html = String(data: htmlData, encoding: .utf8) else {
        print("Error: Could not fetch puzzle page to get CSRF token")
        if let error = error {
            print("Error details: \(error.localizedDescription)")
        }
        exit(1)
    }
    
    // Extract CSRF token (if present)
    let csrfToken = extractCSRFToken(from: html) ?? ""
    
    // Prepare answer submission
    let answerURLString = "https://adventofcode.com/2025/day/\(day)/answer"
    guard let answerURL = URL(string: answerURLString) else {
        print("Error: Invalid URL: \(answerURLString)")
        exit(1)
    }
    
    var request = createAuthenticatedRequest(url: answerURL)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    // Build form data (URL encode values)
    guard let encodedAnswer = answer.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        print("Error: Could not encode answer")
        exit(1)
    }
    
    var formData = "level=\(level)&answer=\(encodedAnswer)"
    if !csrfToken.isEmpty, let encodedToken = csrfToken.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        formData += "&_token=\(encodedToken)"
    }
    
    request.httpBody = formData.data(using: .utf8)
    
    let (responseData, httpResponse, submitError) = performRequest(request)
    
    if let error = submitError {
        print("Error submitting answer: \(error.localizedDescription)")
        if let httpResp = httpResponse {
            print("HTTP Status: \(httpResp.statusCode)")
        }
        exit(1)
    }
    
    guard let data = responseData, let responseHTML = String(data: data, encoding: .utf8) else {
        print("Error: No response data received")
        exit(1)
    }
    
    // Parse the response to determine the result
    // Advent of Code typically returns messages like:
    // - "That's the right answer!" (success)
    // - "That's not the right answer" (wrong)
    // - "You gave an answer too recently" (rate limit)
    // - "You don't seem to be solving the right level" (wrong level)
    
    let lowercased = responseHTML.lowercased()
    
    if lowercased.contains("that's the right answer") || lowercased.contains("that's correct") {
        print("✓ Correct answer!")
    } else if lowercased.contains("that's not the right answer") {
        if lowercased.contains("too high") {
            print("✗ Wrong answer: Too high")
        } else if lowercased.contains("too low") {
            print("✗ Wrong answer: Too low")
        } else {
            print("✗ Wrong answer")
        }
    } else if lowercased.contains("you gave an answer too recently") {
        print("⚠ Rate limited: Please wait before submitting again")
    } else if lowercased.contains("you don't seem to be solving") {
        print("⚠ Wrong level: Make sure you're submitting to the correct part (1 or 2)")
    } else if lowercased.contains("already complete") {
        print("ℹ This puzzle part is already complete")
    } else {
        print("Response received (check \(String(format: "day%02d.html", day)) for details)")
        // Print a snippet of the response for debugging
        if let articleRange = responseHTML.range(of: "<article>") {
            let snippet = String(responseHTML[articleRange.upperBound...]).prefix(200)
            print("Response snippet: \(snippet)...")
        }
    }
}

// MARK: - Main Function

func main() {
    let arguments = CommandLine.arguments
    
    guard arguments.count >= 2 else {
        print("Usage:")
        print("  swift aoc.swift puzzle <day>          - Download puzzle description")
        print("  swift aoc.swift submit <day> <level> <answer>  - Submit an answer")
        print("")
        print("Examples:")
        print("  swift aoc.swift puzzle 1")
        print("  swift aoc.swift submit 1 1 12345")
        exit(1)
    }
    
    let command = arguments[1]
    
    switch command {
    case "puzzle":
        guard arguments.count == 3, let day = Int(arguments[2]), day >= 1, day <= 25 else {
            print("Error: puzzle command requires a day number (1-25)")
            print("Usage: swift aoc.swift puzzle <day>")
            exit(1)
        }
        downloadPuzzle(day: day)
        
    case "submit":
        guard arguments.count == 5,
              let day = Int(arguments[2]), day >= 1, day <= 25,
              let level = Int(arguments[3]), level == 1 || level == 2 else {
            print("Error: submit command requires day (1-25), level (1 or 2), and answer")
            print("Usage: swift aoc.swift submit <day> <level> <answer>")
            exit(1)
        }
        let answer = arguments[4]
        submitAnswer(day: day, level: level, answer: answer)
        
    default:
        print("Error: Unknown command '\(command)'")
        print("Use 'puzzle' to download puzzle or 'submit' to submit an answer")
        exit(1)
    }
}

main()
