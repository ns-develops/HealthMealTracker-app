import Foundation
import FirebaseFirestore

class VegetableUploader: ObservableObject {
    private let db = Firestore.firestore()
    @Published var vegetables: [Vegetable] = []

    func uploadVegetables() {
        // firebase control
        db.collection("vegetables").getDocuments { snapshot, error in
            if let error = error {
                print("Error checking vegetables: \(error.localizedDescription)")
                return
            }

            if let snapshot = snapshot, !snapshot.documents.isEmpty {
                print("Vegetables already uploaded.")
                self.fetchVegetables()
                return
            }

            self.performUpload()
        }
    }

    private func performUpload() {
        let vegetablesToUpload: [Vegetable] = [
            Vegetable(name: "Broccoli", vitamins: ["A": 623, "C": 89.2, "K": 101.6]),
            Vegetable(name: "Spinach", vitamins: ["A": 469, "C": 28.1, "K": 483]),
            Vegetable(name: "Kale", vitamins: ["A": 9990, "C": 120, "K": 817]),
            Vegetable(name: "Carrot", vitamins: ["A": 835, "C": 5.9]),
            Vegetable(name: "Bell Pepper", vitamins: ["A": 3131, "C": 127.7]),
            Vegetable(name: "Peas", vitamins: ["A": 765, "C": 40]),
            Vegetable(name: "Brussels Sprouts", vitamins: ["A": 38, "C": 85]),
            Vegetable(name: "Cauliflower", vitamins: ["C": 48.2]),
            Vegetable(name: "Beetroot", vitamins: ["C": 4.9]),
            Vegetable(name: "Zucchini", vitamins: ["A": 200, "C": 17.9])
        ]

        for veg in vegetablesToUpload {
            let data: [String: Any] = [
                "name": veg.name,
                "vitamins": veg.vitamins
            ]

            db.collection("vegetables").addDocument(data: data) { error in
                if let error = error {
                    print("Upload error for \(veg.name): \(error.localizedDescription)")
                } else {
                    print("\(veg.name) uploaded.")
                    DispatchQueue.main.async {
                        self.vegetables.append(veg)
                    }
                }
            }
        }
    }

    func fetchVegetables() {
        db.collection("vegetables").getDocuments { snapshot, error in
            if let error = error {
                print("Fetch error: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            self.vegetables = documents.compactMap { doc in
                let data = doc.data()
                guard let name = data["name"] as? String,
                      let vitamins = data["vitamins"] as? [String: Double] else {
                    return nil
                }
                return Vegetable(name: name, vitamins: vitamins)
            }
        }
    }
}
