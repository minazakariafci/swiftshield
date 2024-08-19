import Foundation

#if os(macOS) || os(Linux)
struct TaskRunner: TaskRunnerProtocol {
    func runTask(withCommand command: String, arguments: [String]) -> TaskRunnerOutput {
        let task = Process()
        task.launchPath = command
        task.arguments = arguments

        let outpipe = Pipe()
        task.standardOutput = outpipe
        task.standardError = outpipe

        task.launch()

        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()

        task.waitUntilExit()

        let outputString = String(data: outdata, encoding: .utf8)
        return TaskRunnerOutput(output: outputString, terminationStatus: task.terminationStatus)
    }
}
#else
struct TaskRunner: TaskRunnerProtocol {
    func runTask(withCommand command: String, arguments: [String]) -> TaskRunnerOutput {
        // Provide a no-op or alternative implementation
        return TaskRunnerOutput(output: "Not supported on this platform", terminationStatus: -1)
    }
}
#endif
