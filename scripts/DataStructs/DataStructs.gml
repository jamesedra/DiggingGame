function Vector2(_x = 0, _y = 0) constructor {
    x = _x; 
    y = _y;

    // shared (static) methods — created once per constructor:
    static add = function(v) { return new Vector2(x + v.x, y + v.y); };
    static sub = function(v) { return new Vector2(x - v.x, y - v.y); };
    static mul = function(k) { return new Vector2(x * k,   y * k  ); };

    static length_sq = function() { return x*x + y*y; };
    static length    = function() { return sqrt(x*x + y*y); };
    static normalized = function() {
        var len = sqrt(x*x + y*y);
        return (len == 0) ? new Vector2(0,0) : new Vector2(x/len, y/len);
    };
}

function Vector3(_x = 0, _y = 0, _z = 0) constructor {
    x = _x; y = _y; z = _z;

    static add = function(v) { return new Vector3(x + v.x, y + v.y, z + v.z); };
    static sub = function(v) { return new Vector3(x - v.x, y - v.y, z - v.z); };
    static mul = function(k) { return new Vector3(x * k,   y * k,   z * k  ); };

    static length_sq = function() { return x*x + y*y + z*z; };
    static length    = function() { return sqrt(x*x + y*y + z*z); };
    static normalized = function() {
        var len = sqrt(x*x + y*y + z*z);
        return (len == 0) ? new Vector3(0,0,0) : new Vector3(x/len, y/len, z/len);
    };
}
