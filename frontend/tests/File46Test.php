<?php
use PHPUnit\Framework\TestCase;
use Demo\File46;

class File46Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File46::add(2, 3));
    }
}
