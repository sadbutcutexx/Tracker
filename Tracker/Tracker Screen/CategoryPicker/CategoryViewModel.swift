import Foundation

final class CategoryViewModel {

    // MARK: - Bindings

    var onCategoriesChanged: (() -> Void)?

    var onCategorySelected: ((String) -> Void)?

    // MARK: - Properties

    private(set) var categories: [TrackerCategory] = []

    private(set) var selectedCategory: String?

    // MARK: - Init

    init() {
        fetchCategories()
    }

    // MARK: - Public MEthods

    func fetchCategories() {

        categories = TrackerCategoryStore.shared.fetchCategories()
        onCategoriesChanged?()
    }

    func createCategory(title: String) {

        do {
            try TrackerCategoryStore.shared.addCategory(
                title: title
            )

            fetchCategories()

        } catch {
            print(error)
        }
    }

    func selectCategory(at index: Int) {
        let category = categories[index]

        selectedCategory = category.title
        onCategorySelected?(category.title)
    }
}
