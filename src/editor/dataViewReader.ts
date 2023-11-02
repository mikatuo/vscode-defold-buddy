//
// Simple wrapper around DataView that auto-advances the read offset and provides
// a few common data type conversions specific to this app

import { TextDecoder } from "util";

export class DataViewReader {
    DataView: any;
    Offset: number;

    constructor(data_view: any, offset: number)
    {
        this.DataView = data_view;
        this.Offset = offset;
    }

    AtEnd() {
        return this.Offset >= this.DataView.byteLength;
    }

    GetBool () {
        let v = this.DataView.getUint8(this.Offset);
        this.Offset++;
        return v;
    }

    GetUInt8 () {
        let v = this.DataView.getUint8(this.Offset);
        this.Offset++;
        return v;
    }

    GetInt32 () {
        let v = this.DataView.getInt32(this.Offset, true);
        this.Offset += 4;
        return v;
    }

    GetUInt32 () {
        var v = this.DataView.getUint32(this.Offset, true);
        this.Offset += 4;
        return v;
    }

    GetFloat32() {
        const v = this.DataView.getFloat32(this.Offset, true);
        this.Offset += 4;
        return v;
    }

    GetInt64() {
        var v = this.DataView.getFloat64(this.Offset, true);
        this.Offset += 8;
        return v;
    }

    GetUInt64() {
        var v = this.DataView.getFloat64(this.Offset, true);
        this.Offset += 8;
        return v;
    }

    GetFloat64() {
        var v = this.DataView.getFloat64(this.Offset, true);
        this.Offset += 8;
        return v;
    }

    GetStringOfLength(string_length: number) {
        const uint8array = new Uint8Array(this.DataView.buffer, this.Offset, string_length);
        this.Offset += string_length;
        const string = new TextDecoder().decode(uint8array);
        return string;
    }

    GetString() {
        var string_length = this.GetUInt32();
        return this.GetStringOfLength(string_length);
    }
}