import Foundation

class Hewan {
    var berat: Int
    var nama: String

    init(berat: Int, nama: String) {
        self.berat = berat
        self.nama = nama
    }
}

class Sapi: Hewan {
    override init(berat: Int, nama: String) {
        super.init(berat: berat, nama: nama)
    }
}

struct HewanMuatan {
    var muatan: [String]

    init(muatan: [String] = []) {
        self.muatan = muatan
    }

    mutating func tambahMuatan(hewan: Hewan) {
        muatan.append(hewan.nama)
    }
}

class Mobil {
    var kapasitasMuatan: Int = 600
    var hewanMuatan: HewanMuatan = HewanMuatan()
    var totalMuatan: Int = 0
    var totalBerat: Int = 0

    func tambahMuatan(hewan: Hewan, completion: (Any) -> Void) {
        if totalBerat + hewan.berat <= kapasitasMuatan {
            hewanMuatan.tambahMuatan(hewan: hewan)
            totalBerat += hewan.berat
            totalMuatan += 1
            completion(totalBerat)
        } else {
            completion("Sudah melebihi kapasitas")
        }
    }

    func getListHewanMuatan() -> [String] {
        return hewanMuatan.muatan
    }
}

let a = Mobil()
let sapi = Sapi(berat: 200, nama: "sapi")

let arraySapi: [Hewan] = [sapi, sapi, sapi, sapi]

for i in arraySapi {
    a.tambahMuatan(hewan: i) { result in
        if let totalBerat = result as? Int {
            print("Berat hewan yang ditambah = \(totalBerat)")
            print("Total muatan = \(a.totalMuatan)")
            print("List hewan yang ditambah = \(a.getListHewanMuatan())")
        } else if let message = result as? String {
            print(message)
        }
    }
}
