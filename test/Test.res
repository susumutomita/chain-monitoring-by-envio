open RescriptMocha
open Mocha
open Belt

describe("Greeter template tests", () => {
  it("A NewGreeting event creates a User entity", () => {
    // Initializing the mock database
    let mockDbInitial = TestHelpers.MockDb.createMockDb()

    // Initializing values for mock event
    let userAddress = Ethers.Addresses.defaultAddress
    let greeting = "Hi there"

    // Creating a mock event
    let mockNewGreetingEvent = TestHelpers.Greeter.NewGreeting.createMockEvent({
      greeting,
      user: userAddress,
    })

    // Processing the mock event on the mock database
    let updatedMockDb = TestHelpers.Greeter.NewGreeting.processEvent({
      event: mockNewGreetingEvent,
      mockDb: mockDbInitial,
    })

    // Expected entity that should be created
    let expectedUserEntity: Types.userEntity = {
      id: userAddress->Ethers.ethAddressToString,
      latestGreeting: greeting,
      numberOfGreetings: 1,
      greetings: [greeting],
    }

    // Getting the entity from the mock database
    let actualUserEntity =
      updatedMockDb.entities.user.get(userAddress->Ethers.ethAddressToString)->Option.getExn

    // Asserting that the entity in the mock database is the same as the expected entity
    Assert.deep_equal(expectedUserEntity, actualUserEntity)
  })

  it("2 Greetings from the same users results in that user having a greeter count of 2", () => {
    // Initializing the mock database
    let mockDbInitial = TestHelpers.MockDb.createMockDb()

    // Initializing values for mock event
    let userAddress = Ethers.Addresses.defaultAddress
    let greeting = "Hi there"
    let greetingAgain = "Oh hello again"

    // Creating a mock event
    let mockNewGreetingEvent = TestHelpers.Greeter.NewGreeting.createMockEvent({
      greeting,
      user: userAddress,
    })

    // Creating a mock event
    let mockNewGreetingEvent2 = TestHelpers.Greeter.NewGreeting.createMockEvent({
      greeting: greetingAgain,
      user: userAddress,
    })

    // Processing the mock event on the mock database
    let updatedMockDb = TestHelpers.Greeter.NewGreeting.processEvent({
      event: mockNewGreetingEvent,
      mockDb: mockDbInitial,
    })

    // Processing the mock event on the updated mock database
    let updatedMockDb2 = TestHelpers.Greeter.NewGreeting.processEvent({
      event: mockNewGreetingEvent2,
      mockDb: updatedMockDb,
    })

    let expectedGreetingCount = 2

    // Getting the entity from the mock database
    let actualUserEntity =
      updatedMockDb2.entities.user.get(userAddress->Ethers.ethAddressToString)->Option.getExn

    // Asserting that the field value of the entity in the mock database is the same as the expected field value
    Assert.equal(actualUserEntity.numberOfGreetings, expectedGreetingCount)
  })

  it(
    "2 Greetings from the same users results in the latest greeting being the greeting from the second event",
    () => {
      // Initializing the mock database
      let mockDbInitial = TestHelpers.MockDb.createMockDb()

      // Initializing values for mock event
      let userAddress = Ethers.Addresses.defaultAddress
      let greeting = "Hi there"
      let greetingAgain = "Oh hello again"

      // Creating a mock event
      let mockNewGreetingEvent = TestHelpers.Greeter.NewGreeting.createMockEvent({
        greeting,
        user: userAddress,
      })

      // Creating a mock event
      let mockNewGreetingEvent2 = TestHelpers.Greeter.NewGreeting.createMockEvent({
        greeting: greetingAgain,
        user: userAddress,
      })

      // Processing the mock event on the mock database
      let updatedMockDb = TestHelpers.Greeter.NewGreeting.processEvent({
        event: mockNewGreetingEvent,
        mockDb: mockDbInitial,
      })

      // Processing the mock event on the updated mock database
      let updatedMockDb2 = TestHelpers.Greeter.NewGreeting.processEvent({
        event: mockNewGreetingEvent2,
        mockDb: updatedMockDb,
      })

      // Getting the entity from the mock database
      let actualUserEntity =
        updatedMockDb2.entities.user.get(userAddress->Ethers.ethAddressToString)->Option.getExn

      let expectedGreeting = greetingAgain

      // Asserting that the field value of the entity in the mock database is the same as the expected field value
      Assert.equal(actualUserEntity.latestGreeting, expectedGreeting)
    },
  )
})
