//
//  WeightedGraph.swift
//  GraphKit
//
//  Created by Marcus Rossel on 11.03.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

/// A `Graph` that uses `Edge.Weighted`s
public typealias WeightedGraph<Value, Weight> = Graph<Edge<Value>.Weighted<Weight>> where Weight: Hashable

extension Graph where Edge: WeightedEdge {
   
}
