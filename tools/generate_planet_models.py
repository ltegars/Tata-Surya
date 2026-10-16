"""
Generate lightweight, high-compatibility glTF 2.0 / GLB planet models
for the Jelajah Tata Surya educational app.

Features:
- Valid glTF 2.0 binary container (.glb)
- Pure standard PBR Metallic-Roughness materials
- Correct CCW triangle winding (100% front-facing, backface-culling safe)
- Proper pole caps (0 degenerate triangles)
- Double-sided rendering enabled for maximum viewer compatibility
- Centered at origin with exact float32 accessor bounds (min/max)
- Saturn includes both planet sphere and dual-sided annular ring system
- Strict 0-error / 0-warning compliance with official Khronos glTF-Validator
"""

import json
import math
import os
import struct

def generate_planet_glb(
    output_path: str,
    color: list[float],
    radius: float = 1.0,
    roughness: float = 0.7,
    metallic: float = 0.08,
    is_saturn: bool = False,
    ring_color: list[float] | None = None,
):
    n_lat = 28
    n_lon = 42

    # 1. Sphere Vertices & Normals
    sphere_verts = []
    sphere_norms = []
    for i in range(n_lat + 1):
        theta = math.pi * i / n_lat
        y = radius * math.cos(theta)
        r_sin = radius * math.sin(theta)
        for j in range(n_lon + 1):
            phi = 2.0 * math.pi * j / n_lon
            x = r_sin * math.sin(phi)
            z = r_sin * math.cos(phi)
            sphere_verts.append((x, y, z))
            if i == 0:
                sphere_norms.append((0.0, 1.0, 0.0))
            elif i == n_lat:
                sphere_norms.append((0.0, -1.0, 0.0))
            else:
                sphere_norms.append((x / radius, y / radius, z / radius))

    # 2. Sphere Indices (Strict CCW winding, outward facing, non-degenerate caps)
    sphere_indices = []
    for i in range(n_lat):
        for j in range(n_lon):
            p00 = i * (n_lon + 1) + j
            p01 = p00 + 1
            p10 = (i + 1) * (n_lon + 1) + j
            p11 = p10 + 1
            if i == 0:
                # North pole cap: single outward CCW triangle
                sphere_indices.extend([p00, p10, p11])
            elif i == n_lat - 1:
                # South pole cap: single outward CCW triangle
                sphere_indices.extend([p00, p10, p01])
            else:
                # Body quads split into two outward CCW triangles
                sphere_indices.extend([p00, p10, p11])
                sphere_indices.extend([p00, p11, p01])

    # Packing helper to guarantee exact float32 bounds and 4-byte alignment
    def pack_v3(vlist):
        data = bytearray()
        min_v = [float('inf')] * 3
        max_v = [float('-inf')] * 3
        for v in vlist:
            vf = [struct.unpack('<f', struct.pack('<f', v[k]))[0] for k in range(3)]
            for k in range(3):
                if vf[k] < min_v[k]:
                    min_v[k] = vf[k]
                if vf[k] > max_v[k]:
                    max_v[k] = vf[k]
            data.extend(struct.pack('<fff', vf[0], vf[1], vf[2]))
        return bytes(data), min_v, max_v

    def pack_idx(ilist):
        data = bytearray()
        for idx in ilist:
            data.extend(struct.pack('<H', idx))
        return bytes(data)

    bin_data = bytearray()
    buffer_views = []
    accessors = []

    # Sphere POSITION (Accessor 0, BufferView 0)
    pos_bytes, s_min, s_max = pack_v3(sphere_verts)
    pos_offset = len(bin_data)
    bin_data.extend(pos_bytes)
    while len(bin_data) % 4 != 0:
        bin_data.append(0)
    buffer_views.append({
        'buffer': 0,
        'byteOffset': pos_offset,
        'byteLength': len(pos_bytes),
        'target': 34962,  # ARRAY_BUFFER
    })
    accessors.append({
        'bufferView': 0,
        'byteOffset': 0,
        'componentType': 5126,  # FLOAT
        'count': len(sphere_verts),
        'type': 'VEC3',
        'min': s_min,
        'max': s_max,
    })

    # Sphere NORMAL (Accessor 1, BufferView 1)
    norm_bytes, _, _ = pack_v3(sphere_norms)
    norm_offset = len(bin_data)
    bin_data.extend(norm_bytes)
    while len(bin_data) % 4 != 0:
        bin_data.append(0)
    buffer_views.append({
        'buffer': 0,
        'byteOffset': norm_offset,
        'byteLength': len(norm_bytes),
        'target': 34962,  # ARRAY_BUFFER
    })
    accessors.append({
        'bufferView': 1,
        'byteOffset': 0,
        'componentType': 5126,  # FLOAT
        'count': len(sphere_norms),
        'type': 'VEC3',
    })

    # Sphere INDICES (Accessor 2, BufferView 2)
    idx_bytes = pack_idx(sphere_indices)
    idx_offset = len(bin_data)
    bin_data.extend(idx_bytes)
    while len(bin_data) % 4 != 0:
        bin_data.append(0)
    buffer_views.append({
        'buffer': 0,
        'byteOffset': idx_offset,
        'byteLength': len(idx_bytes),
        'target': 34963,  # ELEMENT_ARRAY_BUFFER
    })
    accessors.append({
        'bufferView': 2,
        'byteOffset': 0,
        'componentType': 5123,  # UNSIGNED_SHORT
        'count': len(sphere_indices),
        'type': 'SCALAR',
    })

    materials = [{
        'name': 'PlanetMaterial',
        'pbrMetallicRoughness': {
            'baseColorFactor': color,
            'metallicFactor': metallic,
            'roughnessFactor': roughness,
        },
        'doubleSided': True,
    }]

    primitives = [{
        'attributes': {'POSITION': 0, 'NORMAL': 1},
        'indices': 2,
        'material': 0,
    }]

    if is_saturn:
        n_seg = 48
        r_in = 1.35
        r_out = 2.25
        ring_verts = []
        ring_norms = []
        for j in range(n_seg + 1):
            phi = 2.0 * math.pi * j / n_seg
            sin_p = math.sin(phi)
            cos_p = math.cos(phi)
            ring_verts.append((r_in * sin_p, 0.0, r_in * cos_p))
            ring_norms.append((0.0, 1.0, 0.0))
            ring_verts.append((r_out * sin_p, 0.0, r_out * cos_p))
            ring_norms.append((0.0, 1.0, 0.0))

        ring_indices = []
        for j in range(n_seg):
            in0 = 2 * j
            out0 = 2 * j + 1
            in1 = 2 * (j + 1)
            out1 = 2 * (j + 1) + 1
            ring_indices.extend([in0, out0, out1])
            ring_indices.extend([in0, out1, in1])

        # Ring POSITION (Accessor 3, BufferView 3)
        rpos_bytes, r_min, r_max = pack_v3(ring_verts)
        rpos_offset = len(bin_data)
        bin_data.extend(rpos_bytes)
        while len(bin_data) % 4 != 0:
            bin_data.append(0)
        buffer_views.append({
            'buffer': 0,
            'byteOffset': rpos_offset,
            'byteLength': len(rpos_bytes),
            'target': 34962,
        })
        accessors.append({
            'bufferView': 3,
            'byteOffset': 0,
            'componentType': 5126,
            'count': len(ring_verts),
            'type': 'VEC3',
            'min': r_min,
            'max': r_max,
        })

        # Ring NORMAL (Accessor 4, BufferView 4)
        rnorm_bytes, _, _ = pack_v3(ring_norms)
        rnorm_offset = len(bin_data)
        bin_data.extend(rnorm_bytes)
        while len(bin_data) % 4 != 0:
            bin_data.append(0)
        buffer_views.append({
            'buffer': 0,
            'byteOffset': rnorm_offset,
            'byteLength': len(rnorm_bytes),
            'target': 34962,
        })
        accessors.append({
            'bufferView': 4,
            'byteOffset': 0,
            'componentType': 5126,
            'count': len(ring_norms),
            'type': 'VEC3',
        })

        # Ring INDICES (Accessor 5, BufferView 5)
        ridx_bytes = pack_idx(ring_indices)
        ridx_offset = len(bin_data)
        bin_data.extend(ridx_bytes)
        while len(bin_data) % 4 != 0:
            bin_data.append(0)
        buffer_views.append({
            'buffer': 0,
            'byteOffset': ridx_offset,
            'byteLength': len(ridx_bytes),
            'target': 34963,
        })
        accessors.append({
            'bufferView': 5,
            'byteOffset': 0,
            'componentType': 5123,
            'count': len(ring_indices),
            'type': 'SCALAR',
        })

        materials.append({
            'name': 'RingMaterial',
            'pbrMetallicRoughness': {
                'baseColorFactor': ring_color or [0.82, 0.72, 0.54, 1.0],
                'metallicFactor': 0.08,
                'roughnessFactor': 0.75,
            },
            'doubleSided': True,
        })

        primitives.append({
            'attributes': {'POSITION': 3, 'NORMAL': 4},
            'indices': 5,
            'material': 1,
        })

    gltf_dict = {
        'asset': {
            'version': '2.0',
            'generator': 'JelajahTataSurya-PlanetGenerator-v2',
        },
        'scene': 0,
        'scenes': [{'nodes': [0]}],
        'nodes': [{'mesh': 0}],
        'meshes': [{'primitives': primitives}],
        'accessors': accessors,
        'bufferViews': buffer_views,
        'buffers': [{'byteLength': len(bin_data)}],
        'materials': materials,
    }

    json_str = json.dumps(gltf_dict, separators=(',', ':'))
    json_bytes = json_str.encode('utf-8')
    while len(json_bytes) % 4 != 0:
        json_bytes += b' '

    chunk0_header = struct.pack('<I4s', len(json_bytes), b'JSON')
    chunk1_header = struct.pack('<I4s', len(bin_data), b'BIN\x00')
    total_length = 12 + 8 + len(json_bytes) + 8 + len(bin_data)
    header = struct.pack('<4sII', b'glTF', 2, total_length)

    os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
    with open(output_path, 'wb') as f:
        f.write(header)
        f.write(chunk0_header)
        f.write(json_bytes)
        f.write(chunk1_header)
        f.write(bin_data)

    print(f'Generated: {output_path} ({total_length} bytes)')


PLANETS = [
    {
        'id': 'mercury',
        'color': [0.70, 0.68, 0.66, 1.0],
        'roughness': 0.85,
        'metallic': 0.08,
    },
    {
        'id': 'venus',
        'color': [0.92, 0.80, 0.54, 1.0],
        'roughness': 0.60,
        'metallic': 0.04,
    },
    {
        'id': 'earth',
        'color': [0.20, 0.52, 0.86, 1.0],
        'roughness': 0.50,
        'metallic': 0.08,
    },
    {
        'id': 'mars',
        'color': [0.85, 0.38, 0.22, 1.0],
        'roughness': 0.75,
        'metallic': 0.08,
    },
    {
        'id': 'jupiter',
        'color': [0.82, 0.62, 0.44, 1.0],
        'roughness': 0.60,
        'metallic': 0.05,
    },
    {
        'id': 'saturn',
        'color': [0.88, 0.78, 0.56, 1.0],
        'roughness': 0.65,
        'metallic': 0.05,
        'is_saturn': True,
        'ring_color': [0.82, 0.72, 0.54, 1.0],
    },
    {
        'id': 'uranus',
        'color': [0.45, 0.78, 0.82, 1.0],
        'roughness': 0.50,
        'metallic': 0.04,
    },
    {
        'id': 'neptune',
        'color': [0.20, 0.42, 0.88, 1.0],
        'roughness': 0.50,
        'metallic': 0.05,
    },
]

def main():
    assets_dir = os.path.join(os.path.dirname(__file__), '..', 'assets', 'models')
    os.makedirs(assets_dir, exist_ok=True)
    for p in PLANETS:
        out_file = os.path.join(assets_dir, f"{p['id']}.glb")
        generate_planet_glb(
            output_path=out_file,
            color=p['color'],
            roughness=p.get('roughness', 0.7),
            metallic=p.get('metallic', 0.08),
            is_saturn=p.get('is_saturn', False),
            ring_color=p.get('ring_color'),
        )

if __name__ == '__main__':
    main()
