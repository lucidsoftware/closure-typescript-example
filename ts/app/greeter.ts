import Statement from 'goog:Statement';

export class Greeter {
    constructor(public statement: Statement) {}
    greet(): string {
        return this.statement.getStatement();
    }
};
