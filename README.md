# SwiftSimpleTree

A nested data structure that’s flexible and easy to use.

Available as an open source Swift library to be incorporated in other apps.

_SwiftSimpleTree_ is part of the [OpenAlloc](https://github.com/openalloc) family of open source Swift software tools.

## SimpleTree

```swift
let foo = SimpleTree<String>(value: "foo")
let bar = foo.addChild(forValue: "bar")
let baz = bar.addChild(forValue: "baz")

print(foo.getFirst(forValue: "baz")?.value)

=> "baz"

print(baz.getParentValues())

=> ["bar", "foo"]

print(foo.getAllChildValues())

=> ["bar", "baz"]
```

## Types

- `typealias Node = SimpleTree<T>` - a tree node, where `T` is your hashable type.

- `typealias ValueSet = Set<T>` - a set of values, where `T` is your hashable type.

## Instance Methods

#### Tree Maintenance

- `init(value: T)`: Initialize a new tree (containing the specified value at the root)

- `func addChild(forValue: T) -> Node`: Append a new node (containing the specified value) to our list of children

#### Node Retrieval

- `func getParent(excludeValues: ValueSet) -> Node?`: Return the immediate parent node, if any. Optional list of parent values to be excluded. A match will cause this function to return nil.

- `func getParents(maxDepth: Int, excludeValues: ValueSet) -> [Node]`: Return the parent nodes, starting with immediate parent. Optional list of parent values to be excluded. A match will exclude further ancestors. Optional limit on depth.

- `func getChildren(maxDepth: Int, excludeValues: ValueSet) -> [Node]`: Fetch child nodes. Optional list of values for children to be excluded, along with their progeny. Traversal is depth-first, with optional limit.

#### Iterators

- `func makeChildIterator(excludeValues: ValueSet) -> AnyIterator<Node>`: Create a iterator to traverse through the children (grandchildren, etc.) of the current node. Traversal is breadth-first. With short circuit of child branches on exclude filter.

- `func makeParentIterator() -> AnyIterator<Node>`: Create a iterator to traverse up the tree through the parents of the current node, starting with the most recent parent, if any.

#### Iterative Node Search

- `func getFirst(forValue: T) -> Node?`: Traverse from the current node to find the first node with the specified value. Includes current node. Traversal is breadth-first.

- `func getFirstChild(forValue: T) -> Node?`: Traverse the children from the current node to find the first child (grandchild, etc.) with the specified value. Traversal is breadth-first.

#### Iterative Node Retrieval

- `func getAll(excludeValues: ValueSet) -> [Node]`: Flatten tree from current node. Includes current node. Optional list of values for children to be excluded, along with their progeny. Traversal is breadth-first.

- `func getAllChildren(excludeValues: ValueSet) -> [Node]`: Get all the child nodes from the current node. Optional list of values for children to be excluded, along with their progeny. Traversal is breadth-first.

#### Value retrieval

- `func getAllChildValues(excludeValues: ValueSet) -> [T]`: Get all the child values from the current node. Optional list of values for children to be excluded, along with their progeny. Traversal is breadth-first.

- `func getAllValues(excludeValues: ValueSet) -> [T]`: Flatten tree from current node. Includes value of current node. Optional list of values for children to be excluded, along with their progeny. Traversal is breadth-first.

- `func getChildValues(maxDepth: Int, excludeValues: ValueSet) -> [T]`: Fetch child values. Optional list of values for children to be excluded, along with their progeny. Traversal is depth-first, with optional limit.

- `func getParentValue(excludeValues: ValueSet) -> T?`: Return the value of the immediate parent node, if any. Optional list of parent values to be excluded. A match will cause this function to return nil.

- `func getParentValues(maxDepth: Int, excludeValues: ValueSet) -> [T]`: Return the values of the parent nodes, starting with immediate parent. Optional list of parent values to be excluded. A match will exclude further ancestors. Optional limit on depth.

## See Also

Swift open-source libraries (by the same author):

* [AllocData](https://github.com/openalloc/AllocData) - standardized data formats for investing-focused apps and tools
* [FINporter](https://github.com/openalloc/FINporter) - library and command-line tool to transform various specialized finance-related formats to the standardized schema of AllocData
* [Compactor](https://github.com/openalloc/Compactor)  - formatters to produce concise representations of numbers, currency, and time intervals

And commercial apps using this library (by the same author):

* [FlowAllocator](https://flowallocator.app/FlowAllocator/index.html) - portfolio rebalancing tool for macOS
* [FlowWorth](https://flowallocator.app/FlowWorth/index.html) - a new portfolio performance and valuation tracking tool for macOS

## License

Copyright 2021 FlowAllocator LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Contributing

Contributions are welcome. You are encouraged to submit pull requests to fix bugs, improve documentation, or offer new features. 

The pull request need not be a production-ready feature or fix. It can be a draft of proposed changes, or simply a test to show that expected behavior is buggy. Discussion on the pull request can proceed from there.

Contributions should ultimately have adequate test coverage. See tests for current entities to see what coverage is expected.