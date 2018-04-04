//
//  Simple Graph.swift
//  GraphKit
//
//  Created by Marcus Rossel on 23.02.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

/// A `Graph` that uses `Edge.Simple`s
public typealias SimpleGraph<Vertex> = Graph<Edge<Vertex>.Simple>
where Vertex: VertexProtocol

extension Graph where Edge: SimpleEdge {
   
}
