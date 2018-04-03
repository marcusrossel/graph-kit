//
//  DirectedGraph.swift
//  GraphKit
//
//  Created by Marcus Rossel on 16.02.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

/// A `Graph` that uses `Edge.Directed`s
public typealias DirectedGraph<Vertex> = Graph<Edge<Vertex>.Directed>
where Vertex: VertexProtocol

extension Graph where Edge: DirectedEdge {
   
}
