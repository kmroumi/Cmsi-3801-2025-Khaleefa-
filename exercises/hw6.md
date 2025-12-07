1. concurrency means multiple tasks are in progress at the same time while parallelism means that mmultiple tasks are running at the same time

2. thread is an actual OS-level execution unit while a task is a piece of work that gets executed by a thread
ex. executor.submit(() -> doWork()) submits a task that a thread runs.

3. In java calling start() on a terminated thread throws IllegalThreadStateException while in Ada calling an entry on a terminated task raises Tasking_Error.

4. Ada waits for all active tasks to finish and Java ends when main ends and all non-daemon threads finish and Go ends immediately when the main goroutine exits even if other goroutines are still running.

5. Unbuffered channels block until both sender and receiver meet, while buffered channels allow sending without waiting until the buffer is full. use unbuffered for synchronization and buffered when producer/consumer speeds differ.

6. A mutex allows only one goroutine to access a resource at a time while an RWMutex lets many readers access simultaneously but gives writers exclusive access. you use RWMutex when reads are frequent and writes are rare.

7. in Go writing to a closed channel causes a panic while reading from a closed channel immediately returns the zero value plus ok == false and you detect closure using v, ok := <-ch and checking if ok is false.

8. The select statement waits on multiple channel operations and executes one that is ready. if multiple cases are ready at the same time Go chooses one pseudo-randomly among them.