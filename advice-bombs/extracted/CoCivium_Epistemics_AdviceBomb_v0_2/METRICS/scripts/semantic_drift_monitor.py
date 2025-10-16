#!/usr/bin/env python3
"""Semantic Drift Monitor (offline)
Computes cosine distance between canonical mission embedding and current Tier‑A docs.
Requires: numpy
Usage: python semantic_drift_monitor.py --embeddings mission.npy current.npy
"""
import argparse, numpy as np, json, sys

def load_vec(path):
    v = np.load(path)
    if v.ndim == 2:
        return v.mean(axis=0)
    return v

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--embeddings', nargs=2, metavar=('MISSION_NPY','CURRENT_NPY'), required=True)
    ap.add_argument('--out', default='semantic_drift.json')
    args = ap.parse_args()
    m = load_vec(args.embeddings[0])
    c = load_vec(args.embeddings[1])
    num = np.dot(m, c)
    den = (np.linalg.norm(m) * np.linalg.norm(c)) + 1e-12
    cos_sim = float(num / den)
    drift = float(1.0 - cos_sim)
    out = {'cosine_similarity': cos_sim, 'semantic_drift': drift}
    with open(args.out, 'w', encoding='utf-8') as f:
        json.dump(out, f, indent=2)
    print(json.dumps(out, indent=2))

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(2)
