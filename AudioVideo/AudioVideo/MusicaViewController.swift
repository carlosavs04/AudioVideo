//
//  ViewController.swift
//  AudioVideo
//
//  Created by Igmar Salazar on 07/03/23.
//

import UIKit
import AVFoundation

class MusicaViewController: UIViewController
{
    
    @IBOutlet weak var sldTimeTrack: UISlider!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imvSong: UIImageView!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblSinger: UILabel!
    @IBOutlet weak var lblSongNumber: UILabel!
    @IBOutlet weak var sgcPaneo: UISegmentedControl!
    @IBOutlet weak var sldVolume: UISlider!
    
    let canciones = ["Back in black", "Crazy", "Let It Be"]
    let artistas = ["AC/DC", "Aerosmith", "The Beatles"]
    let webs = ["https://www.acdc.com", "https://www.aerosmith.com", "https://www.thebeatles.com"]
    var reproductor = AVAudioPlayer()
    var cronometro = Timer()
    let datos = Datos.sharedDatos()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sldVolume.value = datos.volumen
        sgcPaneo.selectedSegmentIndex = Int(datos.paneo) + 1
        setearTrack()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! WebViewController
        vc.pagina = webs[datos.indice]
    }

    
    @IBAction func cambiarTiempo() {
        reproductor.currentTime = Double(sldTimeTrack.value) * reproductor.duration
        ajustarTiempo()
    }
    
    
    @IBAction func cambiarVelocidad() {
        let menu = UIAlertController(title: "MENU DE OPCIONES", message: "Escoge la opción de velocidad de reproducción", preferredStyle: .actionSheet)
        let lenta = UIAlertAction(title: "Lenta", style: .default) { sender in
            self.reproductor.rate = 0.5
            self.datos.velocidad = self.reproductor.rate
        }
        let normal = UIAlertAction(title: "Normal", style: .destructive) { sender in
            self.reproductor.rate = 1.0
            self.datos.velocidad = self.reproductor.rate
        }
        let rapida = UIAlertAction(title: "Rápida", style: .default) { sender in
            self.reproductor.rate = 2.0
            self.datos.velocidad = self.reproductor.rate
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel)
        menu.addAction(lenta)
        menu.addAction(normal)
        menu.addAction(rapida)
        menu.addAction(cancelar)
        
        self.present(menu, animated: true)
    }
    
    
    @IBAction func reproducirPausar(_ sender: UIButton) {
        if reproductor.isPlaying {
            reproductor.pause()
            sender.setImage(UIImage(named: "play.png"), for: .normal)
            cronometro.invalidate()
        }
        
        else {
            reproductor.play()
            sender.setImage(UIImage(named: "pause.png"), for: .normal)
            cronometro = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
                if self.reproductor.currentTime == 0.0 {
                    self.cronometro.invalidate()
                    sender.setImage(UIImage(named: "play.png"), for: .normal)
                }
                self.ajustarTiempo()
            })
        }
    }
    
    @IBAction func panear() {
        reproductor.pan = Float(sgcPaneo.selectedSegmentIndex - 1)
        datos.paneo = reproductor.pan
    }
    
    @IBAction func cambiarVolumen() {
        reproductor.volume = sldVolume.value
        datos.volumen = reproductor.volume
    }
    
    @IBAction func irAnterior(_ sender: UISwipeGestureRecognizer) {
        if datos.indice > 0 {
            datos.indice -= 1
            setearTrack()
        }
    }
    
    @IBAction func irSiguiente(_ sender: UISwipeGestureRecognizer) {
        if datos.indice < canciones.count - 1 {
            datos.indice += 1
            setearTrack()
        }
    }
    
    func setearTrack() {
        let estado = reproductor.isPlaying
        imvSong.image = UIImage(named: canciones[datos.indice] + ".jpg")
        lblSongName.text = canciones[datos.indice]
        lblSinger.text = artistas[datos.indice]
        lblSongNumber.text = String(format: "%i/%i", datos.indice + 1, canciones.count)
        
        if let rutaTrack = Bundle.main.path(forResource: canciones[datos.indice], ofType: "mp3") {
            let urlTrack = URL(fileURLWithPath: rutaTrack)
            do {
                try reproductor = AVAudioPlayer(contentsOf: urlTrack)
                reproductor.enableRate = true
                reproductor.volume = datos.volumen
                reproductor.pan = datos.paneo
                reproductor.rate = datos.velocidad
                
                if estado {
                    reproductor.play()
                }
            } catch {
                let error = UIAlertController(title: "ERROR", message: "No se pudo cargar adecuadamente la canción", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Aceptar", style: .default)
                error.addAction(ok)
                self.present(error, animated: true)
            }
        } else {
            let error = UIAlertController(title: "ERROR", message: "No se pudo cargar adecuadamente la canción", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Aceptar", style: .default)
            error.addAction(ok)
            self.present(error, animated: true)
        }
    }
    
    func ajustarTiempo() {
        let minuto = Int(reproductor.currentTime) / 60
        let segundos = Int(reproductor.currentTime) % 60
        sldTimeTrack.value = Float(reproductor.currentTime / reproductor.duration)
        lblTime.text = String(format: "%i:%02i", minuto, segundos)
    }
}
