//
//  Datos.swift
//  AudioVideo
//
//  Created by imac on 23/03/23.
//

import UIKit

class Datos: NSObject {
    var indice: Int
    var velocidad: Float
    var paneo: Float
    var volumen: Float
    static var datos: Datos!
    
    override init() {
        indice = 0
        velocidad = 1.0
        paneo = 0.0
        volumen = 1.0
    }
    
    static func sharedDatos()->Datos {
        if datos == nil {
            datos = Datos.init()
        }
        
        return datos
    }

}
