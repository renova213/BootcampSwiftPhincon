import Foundation

class Mobil{
    var kapasitasMuatan: Int = 0
    var totalMuatan: Int = 600
    var totalBerat: Int = 0
    var hewanMuatan: HewanMuatan
    
    
}


class Hewan{
    var namaHewan: String
    var berat: Int
    
    init(namaHewan: String, berat: Int) {
        self.namaHewan = namaHewan
        self.berat = berat
    }
}

struct HewanMuatan{
    var muatan : [String]
    
    init(muatan: [String]) {
        self.muatan = muatan
    }
    
    mutating func tambahMuatan (hewan: Hewan){
        muatan.append(hewan.namaHewan)
    }
}

let mobil = Mobil()

let sapi = Hewan(namaHewan: "Sapi", berat: 150)

print(mobil.tambahMuatan(hewan: sapi))
print("Total muatan = \(mobil.totalMuatan)")
print("List hewan yang ditambah = \(mobil.getListHewanMuatan())")
