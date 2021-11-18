//
//  SimpleTreeTests.swift
//
// Copyright 2021 FlowAllocator LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import XCTest

import SimpleTree

/// Shallow equator, exclusively for purposes of testing
extension SimpleTree: Equatable {
    public static func == (lhs: SimpleTree.Node, rhs: SimpleTree.Node) -> Bool {
        lhs.value == rhs.value
    }
}

class SimpleTreeTests: XCTestCase {
   
    public func testGetParentValues() throws {
        let foo = SimpleTree<String>(value: "foo")
        let bar = foo.addChild(forValue: "bar")
        let baz2 = foo.addChild(forValue: "bar2")
        let baz = bar.addChild(forValue: "baz")
        let blah = bar.addChild(forValue: "blah")

        XCTAssertEqual(blah.getParentValues(), ["bar", "foo"])
        XCTAssertEqual(blah.getParentValues(maxDepth: 0), [])
        XCTAssertEqual(blah.getParentValues(maxDepth: 1), ["bar"])
        XCTAssertEqual(blah.getParentValues(maxDepth: 2), ["bar", "foo"])
        XCTAssertEqual(blah.getParentValues(maxDepth: 10000), ["bar", "foo"])

        XCTAssertEqual(blah.getParentValues(excludeValues: ["foo"]), ["bar"])
        XCTAssertEqual(blah.getParentValues(excludeValues: ["bar"]), [])
        XCTAssertEqual(blah.getParentValues(excludeValues: ["bar2"]), ["bar", "foo"])
        XCTAssertEqual(blah.getParentValues(excludeValues: ["baz"]), ["bar", "foo"])
        XCTAssertEqual(blah.getParentValues(excludeValues: ["blah"]), ["bar", "foo"])

        XCTAssertEqual(blah.getParentValue(), "bar")
        XCTAssertEqual(foo.getParentValue(), nil)
        XCTAssertEqual(bar.getParentValue(), "foo")
        XCTAssertEqual(baz2.getParentValue(), "foo")
        XCTAssertEqual(baz.getParentValue(), "bar")
    }
    
    public func testMakeParentIterator() throws {
        let foo = SimpleTree<String>(value: "foo")
        let bar = foo.addChild(forValue: "bar")
        let baz2 = foo.addChild(forValue: "baz2")
        let baz = bar.addChild(forValue: "baz")
        let blah = bar.addChild(forValue: "blah")

        let blahIt = blah.makeParentIterator()
        XCTAssertEqual("bar", blahIt.next()?.value)
        XCTAssertEqual("foo", blahIt.next()?.value)
        XCTAssertNil(blahIt.next()?.value)
        
        let baz2It = baz2.makeParentIterator()
        XCTAssertEqual("foo", baz2It.next()?.value)
        XCTAssertNil(baz2It.next()?.value)
        
        let bazIt = baz.makeParentIterator()
        XCTAssertEqual("bar", bazIt.next()?.value)
        XCTAssertEqual("foo", bazIt.next()?.value)
        XCTAssertNil(bazIt.next()?.value)

        let barIt = bar.makeParentIterator()
        XCTAssertEqual("foo", barIt.next()?.value)
        XCTAssertNil(barIt.next()?.value)

        let fooIt = foo.makeParentIterator()
        XCTAssertNil(fooIt.next()?.value)
    }

    public func testMakeChildIterator() throws {
        let foo = SimpleTree<String>(value: "foo")
        let bar = foo.addChild(forValue: "bar")
        let baz2 = foo.addChild(forValue: "baz2")
        let bleep = baz2.addChild(forValue: "bleep")
        let blort = bleep.addChild(forValue: "blort")
        let baz = bar.addChild(forValue: "baz")
        let blah = bar.addChild(forValue: "blah")

        let blahIt = blah.makeChildIterator()
        XCTAssertNil(blahIt.next()?.value)
        
        let baz2It = baz2.makeChildIterator()
        XCTAssertEqual("bleep", baz2It.next()?.value)
        XCTAssertEqual("blort", baz2It.next()?.value)
        XCTAssertNil(baz2It.next()?.value)
  
        let bleepIt = bleep.makeChildIterator()
        XCTAssertEqual("blort", bleepIt.next()?.value)
        XCTAssertNil(bleepIt.next()?.value)

        let blortIt = blort.makeChildIterator()
        XCTAssertNil(blortIt.next()?.value)
        
        let bazIt = baz.makeChildIterator()
        XCTAssertNil(bazIt.next()?.value)

        let barIt = bar.makeChildIterator()
        XCTAssertEqual("baz", barIt.next()?.value)
        XCTAssertEqual("blah", barIt.next()?.value)
        XCTAssertNil(barIt.next()?.value)

        let fooIt = foo.makeChildIterator()
        XCTAssertEqual("bar", fooIt.next()?.value)
        XCTAssertEqual("baz2", fooIt.next()?.value)
        XCTAssertEqual("baz", fooIt.next()?.value)
        XCTAssertEqual("blah", fooIt.next()?.value)
        XCTAssertEqual("bleep", fooIt.next()?.value)
        XCTAssertEqual("blort", fooIt.next()?.value)
        XCTAssertNil(fooIt.next()?.value)
    }

    public func testGetFirst() throws {
        let foo = SimpleTree<String>(value: "foo")
        let bar = foo.addChild(forValue: "bar")
        let baz = bar.addChild(forValue: "baz")

        XCTAssertNil(foo.getFirstChild(forValue: "foo"))
        XCTAssertEqual(foo.getFirstChild(forValue: "bar"), bar)
        XCTAssertEqual(foo.getFirstChild(forValue: "baz"), baz)
        XCTAssertNil(foo.getFirstChild(forValue: "blah"))

        XCTAssertEqual(foo.getFirst(forValue: "foo"), foo)
        XCTAssertEqual(foo.getFirst(forValue: "bar"), bar)
        XCTAssertEqual(foo.getFirst(forValue: "baz"), baz)
        XCTAssertNil(foo.getFirst(forValue: "blah"))
    }

    public func testGetChildValuesNone() throws {
        let foo = SimpleTree<String>(value: "foo")
        XCTAssertEqual(foo.getChildValues(), [])
    }
    
    public func testGetChildValuesOneChild() throws {
        let foo = SimpleTree<String>(value: "foo")
        _ = foo.addChild(forValue: "bar")
        XCTAssertEqual(foo.getChildValues(), ["bar"])
    }
    
    public func testGetChildValuesOneGrandChild() throws {
        let foo = SimpleTree<String>(value: "foo")
        let bar = foo.addChild(forValue: "bar")
        _ = bar.addChild(forValue: "baz")
        XCTAssertEqual(foo.getChildValues(), ["bar", "baz"])
    }

    public func testGetChildValues() throws {
        let foo = SimpleTree<String>(value: "foo")
        let bar = foo.addChild(forValue: "bar")
        let bar2 = foo.addChild(forValue: "bar2")
        _ = bar2.addChild(forValue: "bar3")
        let baz = bar.addChild(forValue: "baz")
        let blah = bar.addChild(forValue: "blah")
        _ = blah.addChild(forValue: "bleh")

        XCTAssertEqual(foo.getChildValues().sorted(), ["bar", "bar2", "bar3", "baz", "blah", "bleh"].sorted())
        XCTAssertEqual(bar.getChildValues().sorted(), ["baz", "blah", "bleh"].sorted())
        XCTAssertEqual(bar2.getChildValues(), ["bar3"])
        XCTAssertEqual(baz.getChildValues(), [])
        XCTAssertEqual(blah.getChildValues(), ["bleh"])

        XCTAssertEqual(foo.getChildValues(maxDepth: 1000).sorted(), ["bar", "bar2", "bar3", "baz", "blah", "bleh"].sorted())
        XCTAssertEqual(foo.getChildValues(maxDepth: 3).sorted(), ["bar", "bar2", "bar3", "baz", "blah", "bleh"].sorted())
        XCTAssertEqual(foo.getChildValues(maxDepth: 2).sorted(), ["bar", "bar2", "bar3", "baz", "blah"].sorted())
        XCTAssertEqual(foo.getChildValues(maxDepth: 1).sorted(), ["bar", "bar2"].sorted())
        XCTAssertEqual(foo.getChildValues(maxDepth: 0).sorted(), [].sorted())
    }
    
    public func testGetAllChildValues() throws {
        let foo = SimpleTree<String>(value: "foo")
        let bar = foo.addChild(forValue: "bar")
        let bar2 = foo.addChild(forValue: "bar2")
        _ = bar2.addChild(forValue: "bar3")
        let baz = bar.addChild(forValue: "baz")
        let blah = bar.addChild(forValue: "blah")
        _ = blah.addChild(forValue: "bleh")

        XCTAssertEqual(foo.getAllChildValues().sorted(), ["bar", "bar2", "bar3", "baz", "blah", "bleh"].sorted())
        XCTAssertEqual(bar.getAllChildValues().sorted(), ["baz", "blah", "bleh"].sorted())
        XCTAssertEqual(bar2.getAllChildValues(), ["bar3"])
        XCTAssertEqual(baz.getAllChildValues(), [])
        XCTAssertEqual(blah.getAllChildValues(), ["bleh"])
    }

    public func testGetChildValuesExclude() throws {
        let foo = SimpleTree<String>(value: "foo")
        let bar = foo.addChild(forValue: "bar")
        let bar2 = foo.addChild(forValue: "bar2")
        _ = bar2.addChild(forValue: "bar3")
        _ = bar.addChild(forValue: "baz")
        _ = bar.addChild(forValue: "blah")

        XCTAssertEqual(foo.getChildValues(excludeValues: ["bar"]).sorted(), ["bar2", "bar3"].sorted())
        XCTAssertEqual(foo.getChildValues(excludeValues: ["bar2"]).sorted(), ["bar", "baz", "blah"].sorted())
        XCTAssertEqual(bar.getChildValues(excludeValues: ["foo"]).sorted(), ["baz", "blah"].sorted())
        XCTAssertEqual(bar.getChildValues(excludeValues: ["blah"]).sorted(), ["baz"].sorted())
    }
    
    public func testGetChildValues2Exclude() throws {
        let foo = SimpleTree<String>(value: "foo")
        let bar = foo.addChild(forValue: "bar")
        let bar2 = foo.addChild(forValue: "bar2")
        _ = bar2.addChild(forValue: "bar3")
        _ = bar.addChild(forValue: "baz")
        _ = bar.addChild(forValue: "blah")

        //XCTAssertEqual(foo.getChildValues2(excludeValues: ["bar"]), [])
        XCTAssertEqual(foo.getAllChildValues(excludeValues: ["bar2"]), ["bar", "baz", "blah"])
        XCTAssertEqual(foo.getAllChildValues(excludeValues: ["blah"]), ["bar", "bar2", "baz", "bar3"])
        XCTAssertEqual(bar.getAllChildValues(excludeValues: ["foo"]), ["baz", "blah"])
        XCTAssertEqual(bar.getAllChildValues(excludeValues: ["blah"]), ["baz"])
    }

    public func testGetAllValues() throws {
        let foo = SimpleTree<String>(value: "foo")
        let bar = foo.addChild(forValue: "bar")
        let baz = bar.addChild(forValue: "baz")

        XCTAssertTrue(foo.getAllValues().contains("foo"))
        XCTAssertTrue(foo.getAllValues().contains("bar"))
        XCTAssertTrue(foo.getAllValues().contains("baz"))
        XCTAssertFalse(foo.getAllValues().contains("blah"))

        XCTAssertFalse(bar.getAllValues().contains("foo"))
        XCTAssertTrue(bar.getAllValues().contains("bar"))
        XCTAssertTrue(bar.getAllValues().contains("baz"))
        XCTAssertFalse(bar.getAllValues().contains("blah"))

        XCTAssertFalse(baz.getAllValues().contains("foo"))
        XCTAssertFalse(baz.getAllValues().contains("bar"))
        XCTAssertTrue(baz.getAllValues().contains("baz"))
        XCTAssertFalse(baz.getAllValues().contains("blah"))
    }
    
    public func testGetAllValuesExcludeRoot() throws {
        let foo = SimpleTree<String>(value: "foo")
        _ = foo.addChild(forValue: "bar")

        let actual = foo.getAllValues(excludeValues: Set(["foo"]))
        XCTAssertFalse(actual.contains("foo"))
        XCTAssertFalse(actual.contains("bar"))
    }
    
    public func testGetAllValuesExcludeChild() throws {
        let foo = SimpleTree<String>(value: "foo")
        let bar = foo.addChild(forValue: "bar")
        _ = bar.addChild(forValue: "baz")

        let actual = foo.getAllValues(excludeValues: Set(["bar"]))
        XCTAssertTrue(actual.contains("foo"))
        XCTAssertFalse(actual.contains("bar"))
    }
    
    public func testGetAllValuesExcludeSibling() throws {
        let foo = SimpleTree<String>(value: "foo")
        
        let blah = foo.addChild(forValue: "blah")
        _ = blah.addChild(forValue: "bleh")
        
        let bar = foo.addChild(forValue: "bar")
        _ = bar.addChild(forValue: "baz")

        let actual = foo.getAllValues(excludeValues: Set(["blah"]))
        XCTAssertTrue(actual.contains("foo"))
        XCTAssertFalse(actual.contains("blah"))
        XCTAssertFalse(actual.contains("bleh"))
        XCTAssertTrue(actual.contains("bar"))
        XCTAssertTrue(actual.contains("baz"))
    }
}