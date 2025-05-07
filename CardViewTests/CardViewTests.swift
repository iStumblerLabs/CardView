import Testing
import CardView

struct CardViewTests_macOS {

    /*
     @Test func testFormatterRegistry() async throws {
     CardTextView.register(CardDataFormatter(), for:Data.self as! AnyClass)
     await let registeredFormatter = CardTextView.registeredFormatter(for:Data.self as! AnyClass)
     #expect(registeredFormatter.isKind(of: CardDataFormatter.self as! AnyClass))
     }
     */

    @Test func testClearCard() async throws {
        Task { @MainActor in
            let cardView = CardTextView()
            cardView.appendNewline()
            cardView.clearCard()
            #expect(cardView.textStorage.string.isEmpty)
        }
    }

    // MARK: Style Stack

    @Test func testPushStyle() async throws {
        Task { @MainActor in
            let cardView = CardTextView()
            let topStyle = NSMutableParagraphStyle()
            topStyle.alignment = .center
            cardView.push(topStyle)
            #expect( cardView.topStyle == topStyle)
            #expect(cardView.popStyle() == topStyle)
            #expect(cardView.topStyle.isEqual(NSParagraphStyle.default))
        }
    }

    @Test func testPushStyles() async throws {
        Task { @MainActor in
            let cardView = CardTextView()

            let leftStyle = NSMutableParagraphStyle()
            leftStyle.alignment = .left
            cardView.push(leftStyle)

            let centerStyle = NSMutableParagraphStyle()
            centerStyle.alignment = .center
            cardView.push(centerStyle)

            let rightStyle = NSMutableParagraphStyle()
            rightStyle.alignment = .right
            cardView.push(rightStyle)

            #expect(cardView.topStyle == rightStyle)
            #expect(cardView.topStyle == rightStyle)
            #expect(cardView.popStyle() == rightStyle)

            #expect(cardView.topStyle == centerStyle)
            #expect(cardView.topStyle == centerStyle)
            #expect(cardView.popStyle() == centerStyle)

            #expect(cardView.topStyle == leftStyle)
            #expect(cardView.topStyle == leftStyle)
            #expect(cardView.popStyle() == leftStyle)

            #expect(cardView.topStyle.isEqual(NSParagraphStyle.default))
        }
    }

    // MARK: - Promises

    @Test func testPromise() async throws {
        Task { @MainActor in
            let cardView = CardTextView()
            let promise = cardView.appendPromise(attributes: [:])

            #expect(cardView.textStorage.string.isEqual("…"))

            let promised = "Promised"
            cardView.fulfillPromise(promise, with: NSAttributedString(string: promised))
            #expect(cardView.textStorage.string.isEqual(promised))
        }
    }

    @Test func testMultiplePromises() async throws {
        Task { @MainActor in
            let cardView = CardTextView()
            let promise1 = cardView.appendPromise(attributes: [:])
            let promise2 = cardView.appendPromise(attributes: [:])

            #expect(cardView.textStorage.string.isEqual("……"))

            let firstPromised = "First Promised"
            cardView.fulfillPromise(promise1, with: NSAttributedString(string: firstPromised))
            #expect(cardView.textStorage.string.isEqual(firstPromised + "…"))

            let secondPromised = "Second Promised"
            cardView.fulfillPromise(promise2, with: NSAttributedString(string: secondPromised))
            #expect(cardView.textStorage.string.isEqual(firstPromised + secondPromised))
        }
    }

    /*
    @Test func testPromiseWithFormatter() async throws {
        Task { @MainActor in
            let data = "Promised".data(using: .utf8)!
            let cardView = CardTextView()
            let dataFormatter = CardDataFormatter()
            // TODO: needs register formatter
        }
    }
     */
}
