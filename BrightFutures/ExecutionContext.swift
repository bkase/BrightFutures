// The MIT License (MIT)
//
// Copyright (c) 2014 Thomas Visser
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

public protocol ExecutionContext {
    
    func execute(task: () -> ());

}

public class QueueExecutionContext : ExecutionContext {
    
    // This is Approach B from https://github.com/hpique/SwiftSingleton
    public class var main : QueueExecutionContext {
        struct Static {
            static let instance : QueueExecutionContext = QueueExecutionContext(targetQueue: Queue.main)
        }
        return Static.instance
    }
    
    public class var global: QueueExecutionContext {
        struct Static {
            static let instance : QueueExecutionContext = QueueExecutionContext(queue: Queue.global)
        }
        return Static.instance
    }
    
    let queue: Queue
    
    public init(queue q: Queue = Queue(), targetQueue: Queue? = nil) {
        self.queue = q
        
        if let unwrappedTargetQueue = targetQueue {
            dispatch_set_target_queue(self.queue.queue, unwrappedTargetQueue.queue)
        }
    }
    
    public func execute(task: () -> ()) {
        self.queue.execute(task)
    }
}

public class ImmediateExecutionContext : ExecutionContext {
    
    public init() { }
    
    public func execute(task: () -> ())  {
        task()
    }
}