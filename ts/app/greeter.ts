import Message from 'goog:Message';

export class Greeter {
    constructor(public message: Message) {}
    greet(): string {
        return this.message.getMessage();
    }
};
