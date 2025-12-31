export class DatabaseEncoder {
    private static readonly replacements: Record<string, string> = {
        ".": "_dot_",
        "#": "_hash_",
        "$": "_dollar_",
        "[": "_lb_",
        "]": "_rb_",
    };

    static encode(input: string): string {
        let value = input.trim();

        for (const [key, replacement] of Object.entries(
            DatabaseEncoder.replacements
        )) {
            value = value.split(key).join(replacement);
        }

        if (value.length === 0) {
            throw new Error("RTDB key cannot be empty");
        }

        return value;
    }

    static decode(input: string): string {
        let value = input;

        for (const [key, replacement] of Object.entries(
            DatabaseEncoder.replacements
        )) {
            value = value.split(replacement).join(key);
        }

        return value;
    }
}